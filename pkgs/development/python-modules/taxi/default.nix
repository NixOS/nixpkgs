{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  appdirs,
  click,
  flit-core,
  pytestCheckHook,
  freezegun,
}:

buildPythonPackage rec {
  pname = "taxi";
  version = "6.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sephii";
    repo = "taxi";
    rev = version;
    hash = "sha256-FeAfat5/Dq0y/XHFbZnOEgFix2z+dP5GXvAANLTPFP8=";
  };

  build-system = [ flit-core ];

  dependencies = [
    appdirs
    click
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "taxi" ];

  meta = {
    homepage = "https://github.com/sephii/taxi/";
    description = "Timesheeting made easy";
    mainProgram = "taxi";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ jocelynthode ];
  };
}
