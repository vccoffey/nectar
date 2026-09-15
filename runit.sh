#!/usr/bin/env bash
# Start the local Jekyll dev server at http://localhost:4000
set -euo pipefail

cd "$(dirname "$0")"

# .ruby-version pins a version that may not be installed on this machine;
# fall back to the newest installed release in the same minor series.
if command -v rbenv >/dev/null 2>&1 && ! rbenv prefix >/dev/null 2>&1; then
  pinned="$(cat .ruby-version)"
  fallback="$(rbenv versions --bare | grep "^${pinned%.*}\." | sort -V | tail -1 || true)"
  if [ -z "$fallback" ]; then
    echo "Ruby $pinned (.ruby-version) is not installed." >&2
    echo "Install it with: rbenv install $pinned" >&2
    exit 1
  fi
  echo "Ruby $pinned (.ruby-version) is not installed — using $fallback instead."
  export RBENV_VERSION="$fallback"
fi

bundle check >/dev/null 2>&1 || bundle install

exec bundle exec jekyll serve --livereload "$@"
