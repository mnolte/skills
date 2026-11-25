#!/usr/bin/env bash
# Install skills from this repo into Devin.
#   ./install.sh                      symlink all skills globally (~/.config/devin/skills)
#   ./install.sh project-grill        only the named skills
#   ./install.sh -p /path/to/proj     copy into <proj>/.agents/skills (commit it with the project)
#   ./install.sh -l                   list skills and install state
# Global installs are symlinks: `git pull` here updates every project at once.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
global="${XDG_CONFIG_HOME:-$HOME/.config}/devin/skills"
project=""; list=0

while getopts "p:lh" o; do
  case $o in
    p) project="$OPTARG" ;;
    l) list=1 ;;
    *) sed -n '2,6p' "${BASH_SOURCE[0]}"; exit 0 ;;
  esac
done
shift $((OPTIND - 1))

all=(); for d in "$repo"/*/; do [[ -f "$d/SKILL.md" ]] && all+=("$(basename "$d")"); done
skills=("${@:-${all[@]}}")

if (( list )); then
  for s in "${all[@]}"; do
    [[ -L "$global/$s" ]] && st="installed (global)" || st="-"
    echo "$s  $st"
  done; exit 0
fi

for s in "${skills[@]}"; do
  [[ -f "$repo/$s/SKILL.md" ]] || { echo "unknown skill: $s" >&2; exit 1; }
  if [[ -n "$project" ]]; then
    dest="$project/.agents/skills"; mkdir -p "$dest"
    rm -rf "${dest:?}/$s"; cp -r "$repo/$s" "$dest/$s"
    echo "copied  $s -> $dest/$s"
  else
    mkdir -p "$global"
    if [[ -e "$global/$s" && ! -L "$global/$s" ]]; then
      echo "skip $s: $global/$s exists and is not a symlink" >&2; continue
    fi
    ln -sfn "$repo/$s" "$global/$s"
    echo "linked  $s -> $global/$s"
  fi
done
