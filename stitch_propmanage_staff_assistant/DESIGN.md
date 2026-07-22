---https://www.figma.com/design/pvIKeSrUSRYHKObzK9DRGW/AI-Chatbot-UI--Community-?node-id=0-1&m=dev&t=3WICAMvODWmAcYiZ-1
name: Ethereal Management
colors:
  surface: '#131314'
  surface-dim: '#131314'
  surface-bright: '#3a393a'
  surface-container-lowest: '#0e0e0f'
  surface-container-low: '#1c1b1c'
  surface-container: '#201f20'
  surface-container-high: '#2a2a2b'
  surface-container-highest: '#353436'
  on-surface: '#e5e2e3'
  on-surface-variant: '#d9bfd3'
  inverse-surface: '#e5e2e3'
  inverse-on-surface: '#313031'
  outline: '#a28a9c'
  outline-variant: '#544151'
  surface-tint: '#ffaaf6'
  primary: '#ffaaf6'
  on-primary: '#5b005d'
  primary-container: '#ff4dff'
  on-primary-container: '#620064'
  inverse-primary: '#a800ab'
  secondary: '#edb1ff'
  on-secondary: '#520070'
  secondary-container: '#6e208c'
  on-secondary-container: '#e498ff'
  tertiary: '#d6baff'
  on-tertiary: '#40147a'
  tertiary-container: '#b18af1'
  on-tertiary-container: '#441a7f'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffd7f6'
  primary-fixed-dim: '#ffaaf6'
  on-primary-fixed: '#380039'
  on-primary-fixed-variant: '#800083'
  secondary-fixed: '#f9d8ff'
  secondary-fixed-dim: '#edb1ff'
  on-secondary-fixed: '#320046'
  on-secondary-fixed-variant: '#6e208c'
  tertiary-fixed: '#ecdcff'
  tertiary-fixed-dim: '#d6baff'
  on-tertiary-fixed: '#270057'
  on-tertiary-fixed-variant: '#573092'
  background: '#131314'
  on-background: '#e5e2e3'
  surface-variant: '#353436'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '600'
    lineHeight: '1.2'
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-sm:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1'
    letterSpacing: 0.05em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 4px
  container-padding: 24px
  gutter: 16px
  safe-area-top: 44px
---

## Brand & Style

The design system is built on a "Neon Noir" aesthetic—fusing the high-stakes world of property management with a futuristic, AI-driven interface. It targets modern property owners and enterprise managers who value efficiency wrapped in a premium, cutting-edge experience.

The visual narrative is defined by **Glassmorphism** and **Futurism**. We utilize deep, ink-black backgrounds to provide a canvas for vibrant magenta and purple light-leaks. The interface feels weightless, with translucent layers that suggest depth and intelligence. This approach shifts property management from a mundane administrative task to a sophisticated, high-performance command center.

## Colors

The palette is anchored in a true-dark neutral (`#0A0A0B`) to maximize the luminescence of the accent colors. 

- **Primary & Secondary:** A vibrant spectrum of pink and purple is used for AI-driven actions, status indicators, and branding elements.
- **Gradients:** Use the accent gradient for primary calls-to-action and "active state" highlights to simulate energy and processing power.
- **Translucency:** Background surfaces should use a subtle white alpha (`rgba(255, 255, 255, 0.03)`) combined with a backdrop blur of 20px to 40px. This creates the "frosted glass" effect seen in the reference material.

## Typography

This design system uses a dual-sans approach. **Plus Jakarta Sans** provides a friendly yet geometric structure for headlines, ensuring the interface remains approachable despite the dark aesthetic. **Hanken Grotesk** is used for functional text and labels, offering high legibility and a modern, tech-forward feel.

Typography should maintain high contrast—pure white (`#FFFFFF`) for headlines and a slightly muted silver-grey (`#A1A1AA`) for secondary body text. Use bold weights to emphasize AI insights and property metrics.

## Layout & Spacing

The layout follows a **Fluid Grid** model with generous internal safe areas. Content is grouped into logical "pods" or cards that float over the dark background.

- **Mobile:** Single column with 20px side margins. Elements are stacked vertically to prioritize thumb-reachability.
- **Desktop:** 12-column grid with 24px gutters. Use wide gutters to allow the background glows and glass effects to breathe.
- **Rhythm:** All spacing (padding, margin, gaps) must be a multiple of 4px to maintain a strict mathematical harmony.

## Elevation & Depth

Hierarchy is established through **Backdrop Blurs** and **Ambient Glows** rather than traditional drop shadows.

- **Level 1 (Base):** Deep black surface.
- **Level 2 (Cards):** Translucent glass (`0.03` opacity) with a `1px` subtle border.
- **Level 3 (Popovers/Modals):** Increased opacity and a stronger backdrop blur (60px), surrounded by a soft pink/purple outer glow (spread 20px, blur 40px, 0.1 opacity) to simulate light emission.
- **Depth:** Elements "higher" in the stack should have slightly lighter borders and more intense background blurs to distinguish them from the base layer.

## Shapes

The design system utilizes **Pill-shaped** geometry. This soft, rounded approach balances the "coldness" of the dark theme and technical nature of property management.

- **Primary Buttons:** Fully rounded (pill) ends.
- **Input Fields:** Rounded-xl (1.5rem) to maintain a cohesive language with the buttons.
- **Cards:** Rounded-xl (1.5rem).
- **Icons:** Should reside in circular containers or have heavily rounded corner treatments.

## Components

### Buttons
Primary buttons use the linear magenta-to-purple gradient with white text. Secondary buttons are "Ghost" style—a translucent fill with a 1px border. All buttons have a high-hover state where the glow intensity increases.

### Cards
Cards are the primary container for property data. They must feature a subtle top-down gradient border (White to Transparent) to catch the "light" from the top of the screen.

### AI Input Fields
Search and AI command bars should be semi-transparent with a persistent "blinking" accent cursor in primary pink. Use high-contrast icons to denote voice and attachment capabilities.

### Chips & Badges
Status indicators (e.g., "Occupied," "Maintenance") use small, pill-shaped chips with a low-opacity version of the status color and high-saturation text for readability.

### Progress Indicators
Data visualizations and property health scores use neon-glowing stroke lines. Avoid solid fills; prefer gradients and glowing paths to maintain the futuristic aesthetic.
