{
  lib,
  buildPythonPackage,
  buildNpmPackage,

  # build-system
  flit-core,

  # dependencies
  django,
  polib,
  typing-extensions,
  wagtail,
  wagtail-modeladmin,

  # optional-dependencies
  google-cloud-translate,

  # tests
  dj-database-url,
  django-rq,
  fetchFromGitHub,
  freezegun,
  python,
}:
let
  pname = "wagtail-localize";

  version = "1.14.5";

  src = fetchFromGitHub {
    repo = "wagtail-localize";
    owner = "wagtail";
    tag = "v${version}";
    hash = "sha256-3T3o2whNNWSbsggNhPI6vnxeONGpNdD2/BMiFl/nWmo=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    npmDepsHash = "sha256-5TKYDFYF8H1UrSUWeKDd/lf0Twk1mVKrPL9ywsdSdz4=";

    NODE_OPTIONS = "--openssl-legacy-provider";

    inherit version src;

    installPhase = ''
      runHook preInstall

      mkdir $out

      for static_dir in src/wagtail_localize/static; do
        cp --parents -r $static_dir $out
      done

      runHook postInstall
    '';
  };
in

buildPythonPackage rec {
  inherit pname version src;

  pyproject = true;

  build-system = [ flit-core ];

  dependencies = [
    django
    polib
    typing-extensions
    wagtail
    wagtail-modeladmin
  ];

  optional-dependencies = {
    google = [ google-cloud-translate ];
  };

  nativeCheckInputs = [
    dj-database-url
    django-rq
    freezegun
    google-cloud-translate
  ];

  preBuild = ''
    cp -r ${assets}/src/wagtail_localize/static src/wagtail_localize/
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} testmanage.py test

    runHook postCheck
  '';

  meta = {
    description = "Translation plugin for Wagtail CMS";
    homepage = "https://github.com/wagtail/wagtail-localize";
    changelog = "https://github.com/wagtail/wagtail-localize/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
