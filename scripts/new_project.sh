#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: ./scripts/new_project.sh <project-slug>" >&2
  exit 1
fi

slug="$1"
if ! [[ "$slug" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Project slug must use lowercase letters, numbers, and hyphens only." >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
date_prefix="$(date +%F)"
project_dir="$repo_root/projects/${date_prefix}_${slug}"

if [ -e "$project_dir" ]; then
  echo "Project already exists: $project_dir" >&2
  exit 1
fi

mkdir -p "$(dirname "$project_dir")"
cp -R "$repo_root/templates/project-template" "$project_dir"

# Remove placeholder files copied only to keep empty template directories in git.
find "$project_dir" -name .gitkeep -delete

echo "Created project: $project_dir"
