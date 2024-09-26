{
  lib,
  knot-resolver,
  writeText,
  python3Packages,
}:

python3Packages.buildPythonPackage {
  pname = "knot-resolver";
  inherit (knot-resolver) version src;

  patches = [
    # Rewrap the two supervisor's binaries, so that they obtain access to python modules
    # defined in the manager.  Those are then used as extensions of supervisord.
    # Manager needs this fixed bin/supervisord on its $PATH.
    (writeText "rewrap-supervisor.patch" ''
      --- a/setup.py
      +++ b/setup.py
      @@ -30,2 +30,4 @@
       {'console_scripts': ['knot-resolver = knot_resolver.manager.main:main',
      +                     'supervisord = supervisor.supervisord:main',
      +                     'supervisorctl = supervisor.supervisorctl:main',
                            'kresctl = knot_resolver.client.main:main']}
    '')
  ];

  # Propagate meson config from the C part to the python part.
  postPatch = ''
    cp '${knot-resolver.config_py}'/knot_resolver/constants.py ./python/knot_resolver/constants.py
  '';

  # Deps can be seen in ${src}/pyproject.toml
  propagatedBuildInputs = with python3Packages; [
    aiohttp
    jinja2
    pyyaml
    prometheus-client
    supervisor
  ];

  doCheck = false; # FIXME
  checkInputs = with python3Packages; [ pytestCheckHook pytest-asyncio pyparsing ];

  meta = knot-resolver.meta // {
    mainProgram = "knot-resolver";
  };
}
