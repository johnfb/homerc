def _main():
    import os
    import site
    import sys
    from distutils.sysconfig import get_python_lib
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
        for plat_specific in (False, True):
            np = get_python_lib(plat_specific=plat_specific, prefix=p)
            if os.path.isdir(np):
                site.addsitedir(np, known_paths)

_main()
del _main
