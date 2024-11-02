{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  appdirs,
  requests,
  click,
  setuptools,
  pytestCheckHook,
  freezegun,
}:

buildPythonPackage rec {
  pname = "taxi";
  version = "6.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sephii";
    repo = "taxi";
    rev = version;
    hash = "sha256-QB88RpgzrQy7DGeRdMHC2SV5Esp/r5LZtlaY5C8vJxw=";
  };

  propagatedBuildInputs = [
    appdirs
    requests
    click
    setuptools
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
