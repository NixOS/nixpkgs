{
  lib,
  buildPythonPackage,
  dj-database-url,
  fetchFromGitHub,
  flit-core,
  python,
  pythonOlder,
  wagtail,
}:

buildPythonPackage rec {
  pname = "wagtail-modeladmin";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail-nest";
    rev = "refs/tags/v${version}";
    hash = "sha256-IG7e7YomMM7K2IlJ1Dr1zo+blDPHnu/JeS5csos8ncc=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ wagtail ];

  nativeCheckInputs = [ dj-database-url ];

  pythonImportsCheck = [ "wagtail_modeladmin" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} testmanage.py test
    runHook postCheck
  '';

  meta = with lib; {
    description = "Add any model in your project to the Wagtail admin. Formerly wagtail.contrib.modeladmin";
    homepage = "https://github.com/wagtail-nest/wagtail-modeladmin";
    changelog = "https://github.com/wagtail/wagtail-modeladmin/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
