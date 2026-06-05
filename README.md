# Premium UI Reference Director

A Codex skill for directing premium website, app, and product UI work with a stronger visual reference system.

It combines:

- Muzli for trend awareness and visual culture
- Awwwards for high-end website craft, composition, motion, and polish
- Pageflows for real product flows, conversion paths, onboarding, checkout, settings, and state design
- anbeime/skill for skill-store organization, screenshot-to-design-system workflows, ecommerce video methods, and web-to-app packaging patterns
- Cinematic luxury commerce direction for future-facing ecommerce, AI fashion, and emotionally designed digital products

The goal is to help Codex avoid generic UI output and produce interfaces that feel intentional, useful, commercially sharp, and visually memorable.

## What This Skill Does

- Establishes a top-level creative direction before UI generation.
- Routes website work through trend, craft, and conversion references.
- Routes app work through complete user journeys and product states.
- Encourages premium typography, restrained palettes, cinematic atmosphere, realistic material language, and strong visual hierarchy.
- Adds reusable skill workflow ideas learned from `anbeime/skill`, including screenshot design-system extraction and staged ecommerce storytelling.
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

notes/
  douyin-tiktok-api-codex-playbook.md
  chinese-indie-dev-opportunity-map.md

tools/
  douyin-api-smoke.ps1

output/codex-skill-plugin-video/
  README.md
  script.md
  storyboard.md
  douyin-post.md
  publish-checklist.md
```

## Codex Workflow Notes

- `notes/douyin-tiktok-api-codex-playbook.md` captures a reusable Codex workflow for integrating `Evil0ctal/Douyin_TikTok_Download_API` safely.
- `notes/chinese-indie-dev-opportunity-map.md` turns `1c7/chinese-independent-developer` into a lightweight opportunity radar for Codex skills, plugins, and tool ideas.
- `tools/douyin-api-smoke.ps1` provides a local smoke test wrapper for `/api/hybrid/video_data`.
- `output/codex-skill-plugin-video/` contains the script, storyboard, Douyin post copy, and publishing checklist for a Codex skills/plugins explainer video.

## Notes

This project does not copy designs from Muzli, Awwwards, or Pageflows. It uses those sites as reference categories for taste, craft, and product-flow reasoning.

## License

MIT
