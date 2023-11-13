{ python3
, fetchFromGitHub
, fetchpatch
, nixosTests
, lib

, plugins ? ps: []
}:

let
  py = python3.override {
    packageOverrides = final: prev: {
      django = final.django_4;
      drf-nested-routers = prev.drf-nested-routers.overridePythonAttrs (oldAttrs: {
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
    };
  };

in py.pkgs.buildPythonApplication rec {
  pname = "peering-manager";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mXva4c5Rtjq/jFJl3yGGlVrggzGJ3awN0+xoDnDWBSA=";
  };

  format = "other";

  propagatedBuildInputs = with py.pkgs; [
    django
    djangorestframework
    django-cacheops
    django-debug-toolbar
    django-filter
    django-postgresql-netfields
    django-prometheus
    django-rq
    django-tables2
    django-taggit
    drf-spectacular
    jinja2
    markdown
    napalm
    packaging
    psycopg2
    pynetbox
    pyyaml
    requests
    tzdata
  ] ++ plugins py.pkgs;

  buildPhase = ''
    runHook preBuild
    cp peering_manager/configuration{.example,}.py
    python3 manage.py collectstatic --no-input
    rm -f peering_manager/configuration.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt/peering-manager
    cp -r . $out/opt/peering-manager
    chmod +x $out/opt/peering-manager/manage.py
    makeWrapper $out/opt/peering-manager/manage.py $out/bin/peering-manager \
      --prefix PYTHONPATH : "$PYTHONPATH"
    runHook postInstall
  '';

  passthru = {
    # PYTHONPATH of all dependencies used by the package
    python = py;
    pythonPath = py.pkgs.makePythonPath propagatedBuildInputs;

    tests = {
      inherit (nixosTests) peering-manager;
    };
  };

  meta = with lib; {
    homepage = "https://peering-manager.net/";
    license = licenses.asl20;
    description = "BGP sessions management tool";
    maintainers = teams.wdz.members;
    platforms = platforms.linux;
  };
}
