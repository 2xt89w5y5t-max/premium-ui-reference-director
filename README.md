# Premium UI Reference Director

A Codex skill for directing premium website, app, and product UI work with a stronger visual reference system.

It combines:

- Muzli for trend awareness and visual culture
- Awwwards for high-end website craft, composition, motion, and polish
- Pageflows for real product flows, conversion paths, onboarding, checkout, settings, and state design
- Cinematic luxury commerce direction for future-facing ecommerce, AI fashion, and emotionally designed digital products

The goal is to help Codex avoid generic UI output and produce interfaces that feel intentional, useful, commercially sharp, and visually memorable.

## What This Skill Does

- Establishes a top-level creative direction before UI generation.
- Routes website work through trend, craft, and conversion references.
- Routes app work through complete user journeys and product states.
- Encourages premium typography, restrained palettes, cinematic atmosphere, realistic material language, and strong visual hierarchy.
- Pairs cleanly with other Codex UI skills such as `beautiful-ui-designer`, `frontend-ui-engineering`, `figma-use`, and `github-primer-ui-designer`.

## Install

Copy the skill folder into your Codex skills directory:

```powershell
Copy-Item -Recurse -Force .\skills\premium-ui-reference-director "$env:USERPROFILE\.codex\skills\premium-ui-reference-director"
```

Restart Codex or open a new thread if the skill does not appear immediately.

## Usage

Ask Codex to design, build, polish, or review a website, app, landing page, ecommerce interface, dashboard, or product flow. The skill is configured for implicit invocation when those tasks appear.

Example prompts:

```text
Use $premium-ui-reference-director to design a luxury AI fashion commerce app.
```

```text
Use $premium-ui-reference-director to redesign this SaaS dashboard with stronger product flow and premium visual direction.
```

```text
Use $premium-ui-reference-director with $frontend-ui-engineering to build a polished React landing page.
```

## Repository Structure

```text
skills/premium-ui-reference-director/
  SKILL.md
  agents/openai.yaml
  references/reference-map.md

docs/
  UI参考源规则.md
  UI技能索引.md
```

## Notes

This project does not copy designs from Muzli, Awwwards, or Pageflows. It uses those sites as reference categories for taste, craft, and product-flow reasoning.

## License

MIT
