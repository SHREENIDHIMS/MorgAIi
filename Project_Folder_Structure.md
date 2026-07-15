# Mortgage CRM Intelligent Knowledge Assistant — Project Folder Structure

This structure maps directly to the V3.1 architecture: separate frontend, backend, NLP/ranking services, document pipeline, infra, and evaluation tooling — each independently deployable and testable.

```
mortgage-knowledge-assistant/
│
├── frontend/                              # Next.js + TypeScript + Shadcn/UI
│   ├── src/
│   │   ├── app/
│   │   │   ├── (auth)/
│   │   │   │   ├── login/
│   │   │   │   └── layout.tsx
│   │   │   ├── (dashboard)/
│   │   │   │   ├── search/
│   │   │   │   ├── analytics/
│   │   │   │   ├── admin/
│   │   │   │   │   ├── documents/
│   │   │   │   │   └── users-roles/
│   │   │   │   └── layout.tsx
│   │   │   ├── api/                       # BFF route handlers (proxy to FastAPI)
│   │   │   └── layout.tsx
│   │   ├── components/
│   │   │   ├── ui/                        # Shadcn primitives
│   │   │   ├── search/
│   │   │   │   ├── SearchBar.tsx
│   │   │   │   ├── ResponsePackageCard.tsx
│   │   │   │   ├── ConfidenceBadge.tsx
│   │   │   │   ├── SourceCitation.tsx
│   │   │   │   └── RelatedQuestions.tsx
│   │   │   ├── feedback/
│   │   │   │   └── ThumbsFeedback.tsx
│   │   │   └── analytics/
│   │   │       └── KnowledgeGapTable.tsx
│   │   ├── hooks/
│   │   ├── lib/
│   │   │   ├── api-client.ts
│   │   │   ├── auth.ts
│   │   │   └── types.ts
│   │   └── styles/
│   ├── public/
│   ├── tests/
│   │   ├── unit/
│   │   └── e2e/
│   ├── .env.example
│   ├── next.config.js
│   ├── tailwind.config.ts
│   ├── tsconfig.json
│   └── package.json
│
├── backend/                                # FastAPI application
│   ├── app/
│   │   ├── main.py
│   │   ├── config.py                       # loads ranking weights / thresholds from DB or file
│   │   ├── dependencies.py
│   │   │
│   │   ├── api/
│   │   │   ├── v1/
│   │   │   │   ├── auth.py
│   │   │   │   ├── search.py
│   │   │   │   ├── documents.py
│   │   │   │   ├── feedback.py
│   │   │   │   ├── analytics.py
│   │   │   │   └── admin.py
│   │   │   └── router.py
│   │   │
│   │   ├── query_processing/               # Query Processing Engine
│   │   │   ├── spell_correction.py         # RapidFuzz / SymSpell
│   │   │   ├── normalization.py
│   │   │   ├── intent_detection.py
│   │   │   ├── ner/
│   │   │   │   ├── gliner_extractor.py     # mortgage entities only
│   │   │   │   └── spacy_pipeline.py       # segmentation, POS, lemmatization
│   │   │   ├── query_expansion.py          # synonym dictionary
│   │   │   └── classification.py
│   │   │
│   │   ├── search/                         # Hybrid Search Engine
│   │   │   ├── bm25_search.py               # PostgreSQL full text search
│   │   │   ├── vector_search.py             # Qdrant
│   │   │   ├── metadata_filters.py          # RBAC + active-version pre-filter (enforced HERE)
│   │   │   └── hybrid_orchestrator.py
│   │   │
│   │   ├── ranking/                        # Ranking Engine
│   │   │   ├── rrf.py                       # Reciprocal Rank Fusion
│   │   │   ├── scoring.py                   # freshness, feedback, metadata, version priority
│   │   │   ├── weights_config.py            # initial default weights, DB/config-driven
│   │   │   └── reranker.py                  # cross-encoder (bge-reranker-base/small)
│   │   │
│   │   ├── response/                       # Response Packaging + Validation
│   │   │   ├── package_builder.py           # Title, Excerpts, Steps, Docs, Source, Confidence
│   │   │   ├── confidence_thresholds.py     # initial default thresholds
│   │   │   └── validation.py                # redundant permission/version/confidence safety-net
│   │   │
│   │   ├── documents/                       # Document Pipeline
│   │   │   ├── upload.py
│   │   │   ├── validation.py
│   │   │   ├── ocr.py                       # Tesseract (optional)
│   │   │   ├── text_extraction.py
│   │   │   ├── chunking/
│   │   │   │   ├── structural_chunker.py    # Hybrid Structural Chunking
│   │   │   │   ├── table_chunker.py
│   │   │   │   ├── checklist_chunker.py
│   │   │   │   └── recursive_chunker.py     # fallback for prose
│   │   │   ├── metadata_extraction.py
│   │   │   ├── entity_extraction.py
│   │   │   ├── embedding.py                  # FastEmbed + bge-small-en-v1.5 (ONNX Int8)
│   │   │   └── indexing.py                   # writes to PostgreSQL + Qdrant
│   │   │
│   │   ├── auth/
│   │   │   ├── jwt_handler.py
│   │   │   ├── rbac.py
│   │   │   └── permissions.py
│   │   │
│   │   ├── audit/                           # Audit Logging (V1, distinct from analytics)
│   │   │   ├── audit_logger.py
│   │   │   └── models.py
│   │   │
│   │   ├── knowledge_gap/
│   │   │   └── gap_detector.py
│   │   │
│   │   ├── db/
│   │   │   ├── postgres/
│   │   │   │   ├── models.py
│   │   │   │   ├── migrations/              # Alembic
│   │   │   │   └── session.py
│   │   │   └── qdrant/
│   │   │       ├── client.py
│   │   │       └── collections.py
│   │   │
│   │   └── cache/
│   │       └── redis_client.py               # V2
│   │
│   ├── tests/
│   │   ├── unit/
│   │   ├── integration/
│   │   └── fixtures/
│   ├── alembic.ini
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .env.example
│
├── evaluation/                              # Evaluation Framework
│   ├── datasets/
│   │   └── eval_100_questions.jsonl         # question, expected_document, expected_chunk
│   ├── metrics/
│   │   ├── precision_recall.py
│   │   ├── mrr.py
│   │   ├── ndcg.py
│   │   ├── hit_rate.py
│   │   └── latency_benchmark.py             # includes reranker p95 budget check
│   ├── run_benchmark.py                     # re-run on every ranking/weight/threshold change
│   └── reports/                             # benchmark run history, versioned
│
├── nlp_models/                               # Model assets (not code)
│   ├── embeddings/
│   │   └── bge-small-en-v1.5-onnx-int8/
│   ├── reranker/
│   │   └── bge-reranker-base/
│   └── gliner/
│       └── mortgage-entities/
│
├── infra/
│   ├── docker-compose.yml                   # local dev: postgres, qdrant, redis, minio
│   ├── docker-compose.prod.yml
│   ├── k8s/
│   │   ├── frontend-deployment.yaml
│   │   ├── backend-deployment.yaml
│   │   ├── postgres-statefulset.yaml
│   │   ├── qdrant-statefulset.yaml
│   │   ├── redis-deployment.yaml
│   │   └── ingress.yaml
│   ├── monitoring/
│   │   ├── prometheus/
│   │   │   └── prometheus.yml
│   │   └── grafana/
│   │       └── dashboards/
│   │           ├── search-latency.json
│   │           ├── confidence-distribution.json
│   │           └── knowledge-gaps.json
│   └── terraform/                           # if cloud-provisioned
│
├── scripts/
│   ├── seed_documents.py
│   ├── reindex_all.py
│   ├── backup_qdrant.sh
│   └── migrate_db.sh
│
├── docs/
│   ├── System_Design.md                     # ← companion doc
│   ├── api_reference.md
│   ├── chunking_strategy.md
│   ├── rbac_model.md
│   ├── confidence_and_thresholds.md
│   └── runbook.md
│
├── .github/
│   └── workflows/
│       ├── ci.yml                            # lint, unit tests, type checks
│       ├── eval_on_pr.yml                    # runs evaluation/run_benchmark.py on ranking changes
│       └── deploy.yml
│
├── .env.example
├── docker-compose.yml
├── README.md
└── LICENSE
```

## Notes on structure decisions

- **`metadata_filters.py` lives inside `search/`, not `response/`.** This is deliberate — RBAC and active-version filtering are enforced as a pre-filter at the Hybrid Search stage, not as a late validation step, per the finalized V3.1 design.
- **`response/validation.py`** still exists as a redundant safety-net check, but it is not the primary enforcement point.
- **`ranking/weights_config.py`** and **`response/confidence_thresholds.py`** are intentionally separated from hardcoded logic — both are meant to be DB/config-driven and tuned via `evaluation/run_benchmark.py`.
- **`evaluation/`** is a top-level sibling of `backend/`, not buried inside it — it's meant to run independently in CI (`eval_on_pr.yml`) whenever ranking, weights, or thresholds change.
- **`nlp_models/`** is separated from `backend/app/` to keep model binaries out of the application code path (easier to version, cache, and mount as a volume in containers).
- **`audit/`** is its own module, separate from `analytics/` (which lives under `api/v1/analytics.py` and the dashboard), reflecting that audit logs are a compliance requirement, not an analytics feature.
