def _main():
    import os
    import site
    import sys
    from sysconfig import get_path
    def K(n, *args):
        return args[n]
    paths = os.environ.get('PYTHONHOMESITE')
    if paths is None:
        paths = []
    else:
        paths = paths.split(os.pathsep)
    known_paths = set()
    for path in sys.path:
        try:
            if os.path.exists(path):
                known_paths.add(K(1, *site.makepath(path)))
        except TypeError:
            continue
    for p in paths:
        for name in ('purelib', 'platlib'):
            np = get_path(name, vars={'base': p, 'platbase': p})
            if os.path.isdir(np):
                site.addsitedir(np, known_paths)

_main()
del _main
