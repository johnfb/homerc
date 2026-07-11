# homerc

My home directory dotfiles and bash setup, evolving for 10+ years. It deploys
via symlinks so my preferred shell, prompt, and environment are one line away:

```bash
git clone git@github.com:johnfb/homerc.git && homerc/install.sh && exec bash
```

`install.sh` symlinks everything under `conf/` into `$HOME`. `pre_setup.sh`
and `post_setup.sh` (sourced from `.bashrc`/`.bash_profile`) drive loading
`profile.d/` (all shells) and `rc.d/` (interactive shells), with per-host
overrides.

For testing, isolation, or sharing without touching your real `$HOME`, see
`init_home.sh` — it points a shell at a fake home directory and re-sources
the whole setup there:

```bash
bash --rcfile /path/to/fake/home/init_home.sh
```

See `.claude/CLAUDE.md` for architecture details.
