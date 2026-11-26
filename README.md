# skills

Personal agent skills (Devin, Claude). One folder per skill, each with a `SKILL.md`.

| Skill | Use |
|---|---|
| [project-grill](project-grill/SKILL.md) | Start of a project: interview the user, then write GLOSSARY.md, SPEC.md, DESIGN.md, AGENTS.md, README.md |
| [implement-spec](implement-spec/SKILL.md) | Audit code against SPEC.md/DESIGN.md, then fix gaps and write missing code test-first |

## Install (Linux)
```
./install.sh              # symlink all skills into ~/.config/devin/skills (global)
./install.sh project-grill
./install.sh -p ~/code/myproj   # copy into myproj/.agents/skills (committed with the project)
./install.sh -l           # list
```
Global installs are symlinks, so `git pull` updates every project. Edit skills here, never inside a project.

Both skills use ADRs (`docs/adr/NNNN-title.md`) for significant decisions; DESIGN.md only indexes them.

## Credits
See [CREDITS.md](CREDITS.md).
