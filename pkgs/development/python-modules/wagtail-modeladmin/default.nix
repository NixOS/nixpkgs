{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  wagtail,
  dj-database-url,
  python,
}:

buildPythonPackage rec {
  pname = "wagtail-modeladmin";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wagtail-nest";
    repo = "wagtail-modeladmin";
    tag = "v${version}";
    hash = "sha256-IG7e7YomMM7K2IlJ1Dr1zo+blDPHnu/JeS5csos8ncc=";
  };

  # Fail with `AssertionError`
  # AssertionError: <Warning: level=30,... > not found in [<Warning: ...>]
  postPatch = ''
    substituteInPlace wagtail_modeladmin/test/tests/test_simple_modeladmin.py \
      --replace-fail \
        "def test_model_with_single_tabbed_panel_only(" \
        "def no_test_model_with_single_tabbed_panel_only(" \
      --replace-fail \
        "def test_model_with_two_tabbed_panels_only(" \
        "def no_test_model_with_two_tabbed_panels_only("
  '';

  build-system = [ flit-core ];

  dependencies = [
    wagtail
  ];

  nativeCheckInputs = [ dj-database-url ];

  pythonImportsCheck = [ "wagtail_modeladmin" ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} testmanage.py test

    runHook postCheck
  '';

  meta = {
    description = "Add any model in your project to the Wagtail admin. Formerly wagtail.contrib.modeladmin";
    homepage = "https://github.com/wagtail-nest/wagtail-modeladmin";
    changelog = "https://github.com/wagtail/wagtail-modeladmin/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
