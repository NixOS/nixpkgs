{ python3
, fetchFromGitHub
, fetchpatch
, nixosTests
, lib

, plugins ? ps: []
}:

python3.pkgs.buildPythonApplication rec {
  pname = "peering-manager";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mXva4c5Rtjq/jFJl3yGGlVrggzGJ3awN0+xoDnDWBSA=";
  };

  format = "other";

  propagatedBuildInputs = with python3.pkgs; [
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
  ] ++ plugins python3.pkgs;

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
    python = python3;
    pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;

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
