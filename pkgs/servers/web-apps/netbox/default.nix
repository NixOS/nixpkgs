{ lib
, pkgs
, fetchFromGitHub
, nixosTests
, python3

, plugins ? ps: [] }:

let
  py = python3.override {
    packageOverrides = self: super: {
      django = super.django_3;
      jsonschema = super.jsonschema.overridePythonAttrs (old: rec {
        version = "3.2.0";
        src = self.fetchPypi {
          pname = old.pname;
          inherit version;
          sha256 = "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a";
        };
      });
      lxml = super.lxml.overridePythonAttrs (old: rec {
        version = "4.6.5";
        src = self.fetchPypi {
          pname = old.pname;
          inherit version;
          sha256 = "6e84edecc3a82f90d44ddee2ee2a2630d4994b8471816e226d2b771cda7ac4ca";
        };
      });
      werkzeug = super.werkzeug.overridePythonAttrs (old: rec {
        version = "2.0.3";
        src = self.fetchPypi {
          pname = "Werkzeug";
          inherit version;
          sha256 = "sha256-uGP4/wV8UiFktgZ8niiwQRYbS+W6TQ2s7qpQoWOCLTw=";
        };
      });
      sentry-sdk = super.sentry-sdk.overridePythonAttrs (old: rec {
        disabledTestPaths = old.disabledTestPaths ++ [
          "tests/integrations/flask/test_flask.py"
        ];
      });
    };
  };

  extraBuildInputs = plugins py.pkgs;
in
py.pkgs.buildPythonApplication rec {
    pname = "netbox";
    version = "3.2.1";

    src = fetchFromGitHub {
      owner = "netbox-community";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-iA0KIgaHQh0OsN/tXmTATIlvnf0aLRdjeQ6VkiR9VJ4=";
    };

    format = "other";

    patches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
      ./graphql-3_2_0.patch
    ];

    propagatedBuildInputs = with py.pkgs; [
      django_3
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
      swagger-spec-validator # from drf-yasg[validation]
      graphene-django
      jinja2
      markdown
      markdown-include
      mkdocs-material
      netaddr
      pillow
      psycopg2
      pyyaml
      social-auth-core
      social-auth-app-django
      svgwrite
      tablib
      jsonschema
    ] ++ extraBuildInputs;

    installPhase = ''
      mkdir -p $out/opt/netbox
      cp -r . $out/opt/netbox
      chmod +x $out/opt/netbox/netbox/manage.py
      makeWrapper $out/opt/netbox/netbox/manage.py $out/bin/netbox \
        --prefix PYTHONPATH : "$PYTHONPATH"
    '';

    passthru = {
      # PYTHONPATH of all dependencies used by the package
      pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;

      tests = {
        inherit (nixosTests) netbox;
      };
    };

    meta = with lib; {
      homepage = "https://github.com/netbox-community/netbox";
      description = "IP address management (IPAM) and data center infrastructure management (DCIM) tool";
      license = licenses.asl20;
      maintainers = with maintainers; [ n0emis raitobezarius ];
    };
  }
