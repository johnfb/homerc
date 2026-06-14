# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A home directory configuration management system. It manages dotfiles and shell initialization scripts, deploying them to `$HOME` via symlinks.

## Installation

```bash
./install.sh
```

This runs `conf/.local/bin/linkfarm conf/ $HOME`, which recursively mirrors the `conf/` directory into `$HOME` as relative symlinks. `linkfarm` is a Python script; it handles creating, updating, and removing symlinks, with `--simulate`/`--delete`/`--force` flags.

## Architecture

### Shell initialization flow

`conf/.bashrc` and `conf/.bash_profile` are symlinked into `$HOME`. Both source `pre_setup.sh`, call a setup function, then source `post_setup.sh`.

`pre_setup.sh` defines the framework functions. The core one, `_homerc_base_setup`, collects and sources all `*.sh` files from two directories in sorted filename order:

- `profile.d/` — sourced for **all** shells (login and interactive)
- `rc.d/` — sourced for **interactive shells only**

After sourcing, `post_setup.sh` unsets all the framework functions so they don't pollute the environment.

### Host/arch overrides

Within `profile.d/` and `rc.d/`, subdirectories named `$HOSTNAME`, `$HOSTTYPE`, or `$MACHTYPE` are also sourced (after the top-level files). This is how machine-specific config is handled.

### File naming convention

Scripts are sorted and sourced by filename. The numbering prefix (`01-`, `20-`, `30-`) controls load order. Lower numbers load first.

### Submodules

- `z/` — [z](https://github.com/rupa/z) for frecency-based directory jumping; sourced in `rc.d/30-z.sh`
- `solarized/` — Solarized color scheme assets (not sourced; reference material)
- `terminal-colors/` — terminal color display utility

### Key scripts

| File | Purpose |
|---|---|
| `profile.d/20-path.sh` | `add_path`/`add_path_env`/`init_path`/`deinit_path` helpers for managing `PATH`, `LD_LIBRARY_PATH`, `PKG_CONFIG_PATH`, etc. |
| `rc.d/30-prompt.sh` | Bash prompt with git branch, job count, conda/venv env, and per-command exit status |
| `rc.d/30-history.sh` | Per-hostname history files stored in `~/.history/bash_$HOSTNAME` |
| `rc.d/20-aliases.sh` | Shell aliases (`m` = parallel make, `pd`/`pop` for pushd/popd, etc.) |
| `rc.d/fulger/gpg.sh` | GPG agent setup |

## Logging

Set `HOMERC_LOG_LEVEL` to control verbosity during shell init:

```bash
HOMERC_LOG_LEVEL=debug bash -l  # trace/debug/info/warn/error
```

Default is `warn` for interactive login shells, `error` otherwise.

## Adding new config

- Shell functions/aliases/exports used in all shells → `profile.d/NN-name.sh`
- Interactive-only shell config → `rc.d/NN-name.sh`
- New dotfiles/config dirs → add to `conf/` (they'll be symlinked on next `install.sh` run)
- Machine-specific overrides → `profile.d/$HOSTNAME/` or `rc.d/$HOSTNAME/`
