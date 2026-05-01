---
name: analog_zig-lib-release
description: Create and publish a GitHub release for a Zig library repository. Use this whenever the user asks to cut a release, publish a tag, create a GitHub release, or ship a new library version from build.zig.zon/src/version.zig.
license: MIT
compatibility:
  - claude-code
metadata:
  category: release-automation
  language: zig
---

# Analog Zig Library Release

This skill standardizes the release flow for Zig libraries so tags and GitHub releases are consistent.

## What this skill does

- Reads the library version from `build.zig.zon`.
- Confirms `src/version.zig` matches that version when present.
- Creates tag `v<version>` (example: `v0.0.1`).
- Creates a GitHub release with:
  - Tag: `v<version>`
  - Release name: `<project-name> <version>` (example: `analog-ui 0.0.1`)
- Publishes the release so the final URL looks like:
  - `https://github.com/<owner>/<repo>/releases/tag/v<version>`

## Preconditions

- Run from the repository root.
- `git` and `gh` CLI must be installed.
- `gh auth status` must be authenticated.
- The version-bump commit should already be on `main` (or the release branch you intend to tag).

## Inputs

- Optional explicit version from the user.
- If omitted, default to the version in `build.zig.zon`.

## Workflow

1. Resolve release version.

```bash
VERSION="$(sed -n 's/.*\\.version = "\\([^"]*\\)".*/\\1/p' build.zig.zon | head -n1)"
```

If the user gave a version explicitly, validate it equals the parsed `VERSION`. If it does not match, stop and ask which one should be authoritative.

2. Validate exported library version when file exists.

```bash
if [ -f src/version.zig ]; then
  CODE_VERSION="$(sed -n 's/.*"\\([^"]*\\)".*/\\1/p' src/version.zig | head -n1)"
  [ "$CODE_VERSION" = "$VERSION" ] || {
    echo "Version mismatch: build.zig.zon=$VERSION, src/version.zig=$CODE_VERSION"
    exit 1
  }
fi
```

3. Resolve project name.

Preferred: repository name from `origin` remote.

```bash
PROJECT_NAME="$(basename -s .git "$(git remote get-url origin)")"
```

Fallback when remote is unavailable:

```bash
PROJECT_NAME="$(basename "$PWD")"
```

4. Compute naming.

```bash
TAG="v$VERSION"
RELEASE_NAME="$PROJECT_NAME $VERSION"
```

5. Safety checks before tagging.

```bash
git fetch --tags origin

git rev-parse -q --verify "refs/tags/$TAG" >/dev/null && {
  echo "Tag $TAG already exists locally"
  exit 1
}

git ls-remote --tags origin "refs/tags/$TAG" | grep -q . && {
  echo "Tag $TAG already exists on origin"
  exit 1
}
```

6. Create and push annotated tag.

```bash
git tag -a "$TAG" -m "$RELEASE_NAME"
git push origin "$TAG"
```

7. Create GitHub release.

```bash
gh release create "$TAG" \
  --title "$RELEASE_NAME" \
  --generate-notes
```

8. Return the release URL and key release facts.

Always report:
- tag name
- release name
- commit SHA tagged
- GitHub release URL

## Expected output format

Use this exact concise structure:

```text
Release published
Tag: vX.Y.Z
Name: <project-name> X.Y.Z
Commit: <sha>
URL: https://github.com/<owner>/<repo>/releases/tag/vX.Y.Z
```

## Example

Given:
- `build.zig.zon` version: `0.0.1`
- repo: `analog-ui`

Output should use:
- Tag: `v0.0.1`
- Release name: `analog-ui 0.0.1`
- URL shape: `https://github.com/analog-alex/analog-ui/releases/tag/v0.0.1`

## Notes

- If tag creation or release creation fails, do not retry blindly; inspect and report the exact error.
- Do not modify library versions in this skill. This skill publishes the release for an already chosen version.
