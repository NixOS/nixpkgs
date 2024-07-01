{
  lib,
  buildPythonPackage,
  dj-database-url,
  django,
  django-rq,
  fetchFromGitHub,
  flit-core,
  freezegun,
  google-cloud-translate,
  polib,
  python,
  pythonOlder,
  typing-extensions,
  wagtail,
}:

buildPythonPackage rec {
  pname = "wagtail-modeladmin";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail-nest";
    rev = "refs/tags/v${version}";
    hash = "sha256-J6ViGf7lqUvl5EV4/LbADVDp15foY9bUZygs1dSDlKw=";
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
