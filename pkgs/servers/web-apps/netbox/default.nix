{ lib
, python3
, fetchFromGitHub

, configFile ? false
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_3;
    };
  };
in

with python.pkgs;

buildPythonApplication rec {
  pname = "netbox";
  version = "3.0.7";
  format = "other";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "15231llr36nx6karqdhl3vvcan7g0hxwjxkf40vyalrnavrrh5v4";
  };

  propagatedBuildInputs = [
    django
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
    drf-yasg
    graphene-django
    jinja2
    jsonschema
    markdown
    markdown-include
    netaddr
    packaging
    pillow
    psycopg2
    pyyaml
    svgwrite
    tablib
  ];

  installPhase = ''
    install -d $out/opt/netbox
    cp -r netbox/* $out/opt/netbox
  '';

  postInstall = lib.optionalString (configFile) ''
    cp ${configFile} $out/opt/netbox/netbox/configuration.py
  '';

  doCheck = false; # testing requires a running postgresql instance

  passthru = {
    pythonPath = lib.makeLibPath propagatedBuildInputs;
  };

  meta = with lib; {
    description = "Infrastructure resource modeling for network automation";
    homepage = "https://github.com/netbox-community/netbox";
    license = licenses.asl20;
    maintainers = with maihntainers; [ hexa ];
  };
}
