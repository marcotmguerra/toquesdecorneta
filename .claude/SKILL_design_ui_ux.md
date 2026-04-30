---
name: design-ui-ux
description: >
  Use when building or refining any UI — web (HTML/CSS/JS, React, Vue) or
  Flutter. Triggers: component, page, screen, app, dashboard, landing page,
  widget, layout, "make it look better", or any visual output request.
  Produces production-grade, distinctive interfaces that avoid generic AI aesthetics.
---

## 1 · Decide Before You Code

Answer these four questions mentally before writing a single line:

| Question | What to decide |
|---|---|
| **Purpose** | What is the user here to do? What is the ONE primary action? |
| **Tone** | Pick one extreme and commit: brutally minimal · maximalist · retro-futuristic · organic · luxury · playful · editorial · brutalist · art-deco · industrial · soft/pastel |
| **Differentiation** | What will the user remember after leaving? |
| **Platform** | Web (HTML/CSS/JS · React · Vue) or Flutter? Apply platform-specific rules below. |

> **Rule:** Distinctive aesthetics must never reduce readability, clarity, or ease of use. Bold and usable are not opposites.

---

## 2 · Visual Design Principles (Platform-Agnostic)

### Typography
- Pair one expressive **display font** with one highly readable **body font**.
- Web: load from Google Fonts or Bunny Fonts. Flutter: use `google_fonts` package.
- **Never use:** Arial, Roboto, Inter, system-ui, Space Grotesk as default choices.

### Color
- Use a dominant palette with 1–2 sharp accent colors.
- Define tokens: `--color-bg`, `--color-surface`, `--color-accent`, `--color-text` (web) or `ThemeData` / `ColorScheme` constants (Flutter).
- Ensure WCAG AA contrast on all text/background combinations.

### Motion
- **Web:** CSS transitions first; Motion library for React when available.
- **Flutter:** `AnimatedContainer`, `AnimationController`, `Hero`, `PageTransitionsTheme`.
- Use motion to: guide attention · confirm actions · reveal hierarchy · signal state changes.
- Always provide `prefers-reduced-motion` (web) or respect `AccessibilityFeatures.disableAnimations` (Flutter).

### Layout & Composition
- Intentional asymmetry, overlap, or diagonal flow beats a centered grid.
- Generous negative space OR controlled density — never accidental clutter.
- **Flutter:** prefer `CustomPainter` or `Stack` for non-standard layouts over nested `Column`/`Row` stacks.

### Atmosphere
- Add depth through: textures · grain · translucency · gradient meshes · layered shadows · geometric accents.
- Web: `backdrop-filter`, `mix-blend-mode`, SVG noise filters, `radial-gradient`.
- Flutter: `BackdropFilter`, `ShaderMask`, custom `DecoratedBox` with `BoxDecoration`.

---

## 3 · Platform-Specific Rules

### Web (HTML · CSS · JS · React · Vue)
- Use CSS custom properties for all design tokens.
- Single-file output unless explicitly asked otherwise (HTML+CSS+JS or JSX).
- Animate page load with staggered `animation-delay` reveals.
- External scripts only from `cdnjs.cloudflare.com`.
- React: Tailwind core utilities only (no compiler); hooks via explicit imports.
- No `localStorage` / `sessionStorage` in artifacts — use React state.
- No `<form>` tags in React artifacts — use `onClick`/`onChange` handlers.

### Flutter
- Use **Material 3** (`useMaterial3: true`) or a fully custom theme — never default Material 2 out of the box.
- Define `ColorScheme.fromSeed()` or a hand-crafted `ColorScheme` in `ThemeData`.
- Use `google_fonts` for typography; define `TextTheme` explicitly.
- Prefer `StatelessWidget` + state management (Provider, Riverpod, Bloc) over deep `StatefulWidget` trees.
- Use `LayoutBuilder` + `MediaQuery` for responsive behavior — never hardcode pixel widths.
- Extract reusable widgets into named classes; avoid anonymous widget functions for complex subtrees.
- Animations: start simple (`AnimatedSwitcher`, `AnimatedOpacity`), escalate to `AnimationController` only when needed.
- Always handle: loading → `CircularProgressIndicator` with context · empty → illustrated empty state · error → `SnackBar` or inline error widget with recovery action.
- Ensure `Semantics` labels on interactive widgets for accessibility.
- Target Flutter stable channel; avoid experimental APIs.

---

## 4 · UX Requirements (Both Platforms)

- **5-second clarity:** New user must grasp purpose, audience, and next step within 5 seconds.
- **One dominant CTA:** Secondary actions must not visually compete.
- **Recognition over recall:** Visible labels, clear affordances, no hidden rules.
- **System status:** Every async operation needs a loading, success, and error state.
- **Error messages:** Specific + actionable. Never "Something went wrong."
- **Empty states:** Explain why it's empty and what to do next.
- **Responsive:** Reorganize layout for mobile — don't just scale down.
- **Accessibility:** Contrast · semantic structure · keyboard/focus · touch targets ≥ 48px · screen reader labels.

---

## 5 · States to Always Design

| State | Web | Flutter |
|---|---|---|
| Loading | Skeleton or spinner | `CircularProgressIndicator` / shimmer |
| Empty | Illustration + CTA | Custom `EmptyState` widget |
| Error | Inline message + retry | `SnackBar` or error card |
| Success | Confirmation feedback | `SnackBar` / `AnimatedSwitcher` |
| Disabled | Visual + `aria-disabled` | `onPressed: null` + opacity |
| Hover/Focus | CSS `:hover`, `:focus-visible` | `InkWell` / `MouseRegion` |

---

## 6 · Microcopy Rules

- Buttons describe the action: **"Save draft"** not **"Submit"**.
- Error messages answer: *what happened* + *what to do*.
- Empty states answer: *why empty* + *how to start*.
- No filler slogans that could belong to any product.

---

## 7 · Anti-Patterns (Never Do These)

- Visually impressive but unclear to operate.
- Purple gradients, Inter font, predictable SaaS card layouts as defaults.
- Same aesthetic repeated across different projects.
- Only designing the happy path.
- Accessibility treated as an afterthought.
- Flutter: `Expanded` inside unbounded height without constraints.
- Flutter: hardcoded colors outside `ThemeData`.
- Flutter: `setState` for shared/global state.

---

## 8 · Self-Review Before Delivering

- [ ] Purpose clear in 5 seconds?
- [ ] Primary action unmistakably dominant?
- [ ] All states handled (loading · empty · error · success)?
- [ ] Accessible (contrast · labels · touch targets)?
- [ ] Responsive / adaptive layout?
- [ ] Aesthetic memorable AND usable?
- [ ] No generic AI-slop patterns?
- [ ] Flutter: theme tokens used everywhere, no hardcoded values?

---

> **Final principle:** The goal is not beauty alone — it is an interface that feels *intentionally designed*, *memorable*, and *effortless to use*. Visual boldness, UX clarity, and technical correctness must work as one system.
