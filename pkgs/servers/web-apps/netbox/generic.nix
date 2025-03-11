{
  lib,
  fetchFromGitHub,
  python3,
  version,
  hash,
  plugins ? ps: [ ],
  extraPatches ? [ ],
  tests ? { },
  maintainers ? [ ],
  eol ? false,
}:
let
  extraBuildInputs = plugins python3.pkgs;
in
python3.pkgs.buildPythonApplication rec {
  pname = "netbox";
  inherit version;

  format = "other";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = pname;
    rev = "refs/tags/v${version}";
    inherit hash;
  };

  patches = extraPatches;

  propagatedBuildInputs =
    with python3.pkgs;
    [
      bleach
      boto3
      django_4
      django-cors-headers
      django-debug-toolbar
      django-filter
      django-graphiql-debug-toolbar
      django-mptt
      django-pglocks
      django-prometheus
      django-redis
      django-rq
      django-tables2
      django-taggit
      django-timezone-field
      djangorestframework
      drf-spectacular
      drf-spectacular-sidecar
      drf-yasg
      dulwich
      swagger-spec-validator # from drf-yasg[validation]
      feedparser
      graphene-django
      jinja2
      markdown
      markdown-include
      netaddr
      pillow
      psycopg2
      pyyaml
      requests
      sentry-sdk
      social-auth-core
      social-auth-app-django
      svgwrite
      tablib
      jsonschema
    ]
    ++ extraBuildInputs;

  buildInputs = with python3.pkgs; [
    mkdocs-material
    mkdocs-material-extensions
    mkdocstrings
    mkdocstrings-python
  ];

  nativeBuildInputs = [
    python3.pkgs.mkdocs
  ];

  postBuild = ''
    PYTHONPATH=$PYTHONPATH:netbox/
    python -m mkdocs build
  '';

  installPhase = ''
    mkdir -p $out/opt/netbox
    cp -r . $out/opt/netbox
    chmod +x $out/opt/netbox/netbox/manage.py
    makeWrapper $out/opt/netbox/netbox/manage.py $out/bin/netbox \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  passthru = {
    python = python3;
    # PYTHONPATH of all dependencies used by the package
    pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;
    gunicorn = python3.pkgs.gunicorn;
    inherit tests;
  };

  meta = {
    homepage = "https://github.com/netbox-community/netbox";
    description = "IP address management (IPAM) and data center infrastructure management (DCIM) tool";
    mainProgram = "netbox";
    license = lib.licenses.asl20;
    knownVulnerabilities = (
      lib.optional eol "Netbox version ${version} is EOL; please upgrade by following the current release notes instructions."
    );
    # Warning:
    # Notice the missing `lib` in the inherit: it is using this function argument rather than a `with lib;` argument.
    # If you replace this by `with lib;`, pay attention it does not inherit all maintainers in nixpkgs.
    inherit maintainers;
  };
}
