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
  version = "6.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sephii";
    repo = "taxi";
    rev = version;
    hash = "sha256-zhBjULAPd1rGvTMdy7TJ3XoDDMGnoL6fyZFTVIHDvDI=";
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

  meta = with lib; {
    homepage = "https://github.com/sephii/taxi/";
    description = "Timesheeting made easy";
    mainProgram = "taxi";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ jocelynthode ];
  };
}
