{ lib
, fetchFromGitHub
, fetchpatch
, python3
, version
, hash
, plugins ? ps: []
, extraPatches ? []
, tests ? {}
, maintainers ? []
, eol ? false
}:
  let
    py = python3 // {
      pkgs = python3.pkgs.overrideScope (self: super: {
        django = super.django_4;
        drf-nested-routers = super.drf-nested-routers.overridePythonAttrs (_oldAttrs: {
          patches = [
            # all for django 4 compat
            (fetchpatch {
              url = "https://github.com/alanjds/drf-nested-routers/commit/59764cc356f7f593422b26845a9dfac0ad196120.diff";
              hash = "sha256-mq3vLHzQlGl2EReJ5mVVQMMcYgGIVt/T+qi1STtQ0aI=";
            })
            (fetchpatch {
              url = "https://github.com/alanjds/drf-nested-routers/commit/723a5729dd2ffcb66fe315f229789ca454986fa4.diff";
              hash = "sha256-UCbBjwlidqsJ9vEEWlGzfqqMOr0xuB2TAaUxHsLzFfU=";
            })
            (fetchpatch {
              url = "https://github.com/alanjds/drf-nested-routers/commit/38e49eb73759bc7dcaaa9166169590f5315e1278.diff";
              hash = "sha256-IW4BLhHHhXDUZqHaXg46qWoQ89pMXv0ZxKjOCTnDcI0=";
            })
          ];
        });
      });
    };

    extraBuildInputs = plugins py.pkgs;
  in
  py.pkgs.buildPythonApplication rec {
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

      propagatedBuildInputs = with py.pkgs; [
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
        sentry-sdk
        social-auth-core
        social-auth-app-django
        svgwrite
        tablib
        jsonschema
      ] ++ extraBuildInputs;

      buildInputs = with py.pkgs; [
        mkdocs-material
        mkdocs-material-extensions
        mkdocstrings
        mkdocstrings-python
      ];

      nativeBuildInputs = [
        py.pkgs.mkdocs
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
        # PYTHONPATH of all dependencies used by the package
        pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;
        inherit tests;
      };

      meta = {
        homepage = "https://github.com/netbox-community/netbox";
        description = "IP address management (IPAM) and data center infrastructure management (DCIM) tool";
        license = lib.licenses.asl20;
        knownVulnerabilities = (lib.optional eol "Netbox version ${version} is EOL; please upgrade by following the current release notes instructions.");
        # Warning:
        # Notice the missing `lib` in the inherit: it is using this function argument rather than a `with lib;` argument.
        # If you replace this by `with lib;`, pay attention it does not inherit all maintainers in nixpkgs.
        inherit maintainers;
      };
    }
