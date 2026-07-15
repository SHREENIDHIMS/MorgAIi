# Mortgage CRM Intelligent Knowledge Assistant (V3.1 Final)

## Design Philosophy

**"Find the right information, don't generate new information."**

This ensures:

- No hallucinations
- Compliance-friendly
- Fully auditable
- Deterministic answers
- Enterprise ready

---

## Final Architecture (V3.1)

```
                              USERS
                                │
                                ▼
                  Next.js + Shadcn/UI Frontend
                                │
                                ▼
                         FastAPI Backend
                                │
        ┌───────────────────────┼────────────────────────┐
        ▼                       ▼                        ▼
 Authentication           Query Processing         Feedback API
      (JWT)                     │
                                ▼
 ┌──────────────────────────────────────────────────────────────┐
 │                    Query Processing Engine                   │
 ├──────────────────────────────────────────────────────────────┤
 │ • Spell Correction (RapidFuzz / SymSpell)                    │
 │ • Query Normalization                                        │
 │ • Intent Detection                                           │
 │ • Named Entity Recognition (GLiNER + spaCy — see roles below)│
 │ • Query Expansion (Synonyms, Acronyms)                       │
 │ • Query Classification                                       │
 └──────────────────────────────────────────────────────────────┘
                                │
                                ▼
 ┌──────────────────────────────────────────────────────────────┐
 │              Hybrid Search Engine (with pre-filtering)        │
 ├──────────────────────────────────────────────────────────────┤
 │ PostgreSQL BM25                                              │
 │ Qdrant Semantic Search (Cosine Similarity, HNSW index)       │
 │ Metadata Filtering:                                          │
 │   • RBAC filter (user's role/permission scope)               │
 │   • Active/Approved version filter                           │
 │   • Department/document-type filters                         │
 └──────────────────────────────────────────────────────────────┘
                                │
                                ▼
 ┌──────────────────────────────────────────────────────────────┐
 │                    Ranking Engine                            │
 ├──────────────────────────────────────────────────────────────┤
 │ • Reciprocal Rank Fusion (RRF)                              │
 │ • Freshness Score                                            │
 │ • Feedback Score                                             │
 │ • Version Priority (basic version metadata, see V1 features) │
 │ • Metadata Score                                              │
 └──────────────────────────────────────────────────────────────┘
                                │
                                ▼
 ┌──────────────────────────────────────────────────────────────┐
 │              Cross-Encoder Re-ranking Stage                  │
 ├──────────────────────────────────────────────────────────────┤
 │ Model: bge-reranker-base or bge-reranker-small               │
 │ Scores top-N candidates from RRF (not generative — ranking   │
 │ only)                                                         │
 │ Latency budget: <200ms p95 on candidate set (target ~20      │
 │ chunks) — treated as a hard design constraint, not an        │
 │ afterthought                                                  │
 └──────────────────────────────────────────────────────────────┘
                                │
                                ▼
 ┌──────────────────────────────────────────────────────────────┐
 │                  Response Packaging                           │
 ├──────────────────────────────────────────────────────────────┤
 │ • Title                                                       │
 │ • Matched Excerpt(s)  [retrieved, not generated]              │
 │ • Relevant Steps                                              │
 │ • Required Documents                                          │
 │ • Source Document / Page Number / Section                     │
 │ • Confidence Score                                             │
 │ • Related Questions                                            │
 └──────────────────────────────────────────────────────────────┘
                                │
                                ▼
 ┌──────────────────────────────────────────────────────────────┐
 │              Response Validation (safety net)                 │
 ├──────────────────────────────────────────────────────────────┤
 │ • Confidence Threshold Check (routes response behavior)       │
 │ • Redundant Permission Re-check (belt-and-suspenders,         │
 │   primary enforcement already happened at Hybrid Search)      │
 │ • Redundant Active-Version Re-check (same rationale)          │
 └──────────────────────────────────────────────────────────────┘
                                │
                                ▼
                              USERS
```

**Key change from V3:** RBAC and active/approved-version filtering are now enforced as **metadata filters at the Hybrid Search stage**, before ranking and reranking ever touch the candidate set. This avoids wasting the (relatively expensive) cross-encoder reranking step on documents the user isn't permitted to see, and avoids any restricted content passing through ranking, logging, or caching layers before being filtered. Response Validation still performs a redundant check as a safety net, but it is no longer the *only* enforcement point.

---

## Document Pipeline

```
Upload Document
      │
      ▼
Validation
      │
      ▼
OCR (Optional)
      │
      ▼
Text Extraction
      │
      ▼
Hybrid Structural Chunking
      │
      ▼
Metadata Extraction
      │
      ▼
Entity Extraction
      │
      ▼
Embedding Generation
      │
      ▼
Indexing
      │
      ├────────► PostgreSQL
      │
      └────────► Qdrant
```

### Hybrid Structural Chunking (replaces plain Recursive Chunking)

Mortgage documents contain rate tables, eligibility grids, checklists, and decision trees that recursive text chunking tends to fragment or mangle. Chunking is now structure-aware:

| Source Structure | Chunking Behavior |
|---|---|
| Heading / Section | Section-level chunk |
| Table (rate chart, eligibility grid) | Kept as a single atomic chunk — never split mid-table |
| Checklist | Checklist-level chunk |
| Paragraph / prose | Recursive text chunking (unchanged) |

---

## Final Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Next.js + TypeScript |
| UI | Tailwind CSS + Shadcn/UI |
| Backend | FastAPI |
| Authentication | JWT |
| Database | PostgreSQL |
| Vector Database | Qdrant |
| Cache | Redis |
| Object Storage | MinIO (or local storage for MVP) |
| Search | PostgreSQL Full Text Search (BM25) |
| Semantic Search | Qdrant |
| Re-ranking | bge-reranker-base / bge-reranker-small (cross-encoder) |
| NLP | spaCy |
| NER | GLiNER |
| Embeddings | FastEmbed + BAAI/bge-small-en-v1.5 (ONNX Int8) |
| OCR | Tesseract (optional) |
| Monitoring | Prometheus + Grafana |
| Logging | Loguru |
| Audit Logging | Dedicated audit log store (see Audit Logging section) — separate from application/analytics logging |

---

## Final Algorithms

| Purpose | Algorithm |
|---|---|
| Keyword Search | BM25 |
| Semantic Search | Cosine Similarity |
| Vector Index | HNSW (Qdrant default) |
| Rank Fusion | Reciprocal Rank Fusion (RRF) |
| Re-ranking | Cross-Encoder (bge-reranker-base/small) |
| Spell Correction | RapidFuzz / SymSpell |
| Entity Recognition | GLiNER |
| NLP | spaCy |
| Query Expansion | Synonym Dictionary |
| Chunking | Hybrid Structural Chunking |
| Confidence | Weighted Scoring |

---

## NLP Role Separation

**spaCy** — responsible for:
- Sentence segmentation
- Tokenization
- Lemmatization
- Normalization
- POS tagging
- Dependency parsing

**GLiNER** — responsible only for mortgage-domain entity extraction:
- Lender
- Mortgage Product
- Document
- Property
- Case Number
- Client

---

## Embedding Model

**FastEmbed — BAAI/bge-small-en-v1.5 (ONNX Int8)**

Why:
- ~35 MB RAM
- CPU optimized
- Strong semantic search quality for its size
- Native Qdrant integration
- No PyTorch runtime required
- Production ready

MiniLM is not recommended unless deploying on extremely constrained hardware.

---

## Ranking Formula (Initial Default Weights)

```
Final Score =
40% Semantic Score
30% BM25 Score
15% Metadata Score
10% Feedback Score
5%  Freshness Score
```

These are **initial default weights**, not fixed constants. They live in a database/config file (not hardcoded) and are expected to be re-tuned using production query logs and the Evaluation Framework (below) — not treated as settled values.

---

## Confidence Thresholds (Initial Default Thresholds)

Like the ranking weights, these are starting points to be tuned against the evaluation dataset, not final constants:

| Confidence | Behavior |
|---|---|
| 90–100 | Return directly |
| 75–89 | Return with "Please verify using the cited source" notice |
| 50–74 | Show as low confidence; display top matching documents only |
| Below 50 | No answer found; log as a Knowledge Gap; suggest manual search |

---

## Retrieval Pipeline Detail

```
Search
   │
   ▼
Candidate Selection
   │
   ▼
Cross-Encoder Re-ranking
   │
   ▼
Response Packaging
   │
   ▼
Response Validation
   │
   ▼
User
```

**Response Validation checks (safety net — primary enforcement is upstream at Hybrid Search):**
- Confidence threshold met?
- Document still approved/active? (redundant check)
- User still has permission? (redundant check)

---

## Audit Logging (moved into V1)

Audit logging is distinct from analytics and is treated as a compliance requirement, not a nice-to-have, given the mortgage-data context.

Each audit record captures:
- User
- Query
- Retrieved Documents
- Timestamp
- Confidence Score
- Response ID

---

## Evaluation Framework (new in V1)

Without a benchmark, ranking/threshold/weight changes can't be measured as improvements or regressions.

**Evaluation dataset:**
- 100 questions
- Expected Document
- Expected Chunk

**Metrics tracked per run:**
- Precision@5
- Recall@10
- MRR
- NDCG
- Hit Rate
- Latency (including reranker p95, per the latency budget above)

The benchmark is re-run every time ranking, weights, or thresholds change. Ranking weights and confidence thresholds should not be adjusted without a corresponding benchmark run.

---

## Features (V1)

- Login
- Document Upload
- OCR Support
- PDF/DOCX/PPTX/XLSX Parsing
- Semantic Search
- Keyword Search
- Metadata Search
- RBAC enforced as a pre-filter at search time (not just post-hoc validation)
- Basic Version Metadata (Version / Approved / Active / Last Updated — no full history)
- Related Questions
- Source Citation
- Confidence Score (with defined threshold behavior above)
- Feedback (👍 / 👎)
- Knowledge Gap Detection
- Analytics Dashboard
- Role-Based Access Control
- **Audit Logging** (moved from "missing" to V1)
- **Evaluation Framework** (new)
- **Cross-Encoder Re-ranking** (new)
- **Hybrid Structural Chunking** (replaces plain Recursive Chunking)

## Features (V2)

- Full Document Versioning (history, diffing — beyond the basic V1 metadata)
- Advanced Analytics
- Redis Caching
- Duplicate Detection
- Auto Document Classification
- Department-specific Search
- Conversation Context (non-LLM)
- Advanced Query Suggestions

---

## Summary of Changes from V3 → V3.1

1. Replaced the "Answer" field with a non-generative **Response Package** (Title, Excerpts, Steps, Required Docs, Source, Confidence, Related Questions) to align with the no-generation philosophy.
2. Added a **Cross-Encoder Re-ranking** stage after RRF, with an explicit latency budget (<200ms p95).
3. Split **spaCy vs. GLiNER** responsibilities explicitly to remove redundant NER surface.
4. Moved **basic version metadata** into V1 to resolve the contradiction with "Version Priority" appearing in the ranking formula.
5. Replaced plain Recursive Chunking with **Hybrid Structural Chunking** to handle tables, rate charts, and checklists correctly.
6. Defined explicit **confidence threshold behavior**, labeled as initial defaults subject to tuning.
7. Labeled ranking weights as **initial default weights**, not fixed values.
8. Moved **Audit Logging** into V1 as a compliance requirement, distinct from analytics.
9. Added a formal **Evaluation Framework** (100-question benchmark, tracked metrics, re-run on every ranking change).
10. **Moved RBAC and active-version enforcement from a late-stage "Response Validation" gate to a metadata pre-filter at the Hybrid Search stage**, with Response Validation retained only as a redundant safety-net check — closing a security/efficiency gap in the V3 pipeline.
