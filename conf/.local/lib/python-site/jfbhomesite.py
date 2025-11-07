def _setup():
    import os
    import site
    import sys
    def K(n, *args):
        return args[n]
    paths = os.environ.get('PYTHONHOMESITE')
    if paths is None:
        paths = set()
    else:
        paths = set(paths.split(os.pathsep))
        paths.discard(site.getuserbase())
        for p in site.PREFIXES:
            paths.discard(p)
        paths.discard(sys.base_prefix)
        paths.discard(sys.base_exec_prefix)
        paths.discard(sys.prefix)
        paths.discard(sys.exec_prefix)
    known_paths = set()
    for path in sys.path:
        try:
            if os.path.exists(path):
                known_paths.add(K(1, *site.makepath(path)))
        except TypeError:
            continue
    site.addsitepackages(known_paths, paths)
_setup()
del _setup
