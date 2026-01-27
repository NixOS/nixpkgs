{
  lib,
  buildNpmPackage,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  anyascii,
  beautifulsoup4,
  django,
  django-filter,
  django-modelcluster,
  django-modelsearch,
  django-taggit,
  django-tasks,
  django-treebeard,
  djangorestframework,
  draftjs-exporter,
  laces,
  openpyxl,
  permissionedforms,
  pillow,
  requests,
  telepath,
  willow,

  # tests
  callPackage,
}:
let
  pname = "wagtail";

  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-TnUEydc1D14ICoCcpq9roE5ZREDm/z3nmaazaQcKlJU=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-Uc16K1RZUCnr4qRe2u4yB44F+zYFBxMpEQCz5992RMA=";

    installPhase = ''
      runHook preInstall

      mkdir $out

      for static_dir in wagtail/*/static; do
        cp --parents -r $static_dir $out
      done

      runHook postInstall
    '';
  };
in

buildPythonPackage rec {
  inherit pname version src;

  pyproject = true;

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "django-tasks" ];

  dependencies = [
    anyascii
    beautifulsoup4
    django
    django-filter
    django-modelcluster
    django-modelsearch
    django-taggit
    django-tasks
    django-treebeard
    djangorestframework
    draftjs-exporter
    laces
    openpyxl
    permissionedforms
    pillow
    requests
    telepath
    willow
  ]
  ++ willow.optional-dependencies.heif;

  preBuild = ''
    cp -r ${assets}/wagtail .
  '';

  # Tests are in separate derivation because they require a package that depends
  # on wagtail (wagtail-factories)
  doCheck = false;

  passthru.tests.wagtail = callPackage ./tests.nix { };

  pythonImportsCheck = [ "wagtail" ];

  meta = {
    description = "Django content management system focused on flexibility and user experience";
    mainProgram = "wagtail";
    homepage = "https://github.com/wagtail/wagtail";
    changelog = "https://github.com/wagtail/wagtail/blob/v${version}/CHANGELOG.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
