# Release checklist

## Before release

- [ ] package the skill: `./scripts/package-skill.sh`
- [ ] verify `dist/openclaw-shopify-manager.skill` exists
- [ ] run syntax checks on bundled scripts
- [ ] smoke-test a host/VM setup
- [ ] smoke-test at least one Docker-shaped setup
- [ ] verify README still matches reality
- [ ] confirm no secrets or machine-local junk are staged

## Release flow

- [ ] commit final changes
- [ ] create annotated tag: `git tag -a v0.1.0 -m "v0.1.0"`
- [ ] push branch and tag: `git push origin main --follow-tags`
- [ ] create GitHub release for the tag
- [ ] attach `dist/openclaw-shopify-manager.skill`
- [ ] add short release notes with scope and known limits

## Suggested release notes shape

- what the skill does
- supported deployment models
- major additions since last release
- known limitations
- upgrade notes if config/runtime behavior changed
