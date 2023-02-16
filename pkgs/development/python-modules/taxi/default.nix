{ lib
, buildPythonPackage
, fetchFromGitHub
, appdirs
, requests
, click
, setuptools
, pytestCheckHook
, freezegun
}:

buildPythonPackage rec {
  pname = "taxi";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "sephii";
    repo = "taxi";
    rev = version;
    sha256 = "sha256-iIy3odDX3QzVG80AFp81m8AYKES4JjlDp49GGpuIHLI=";
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
    license = licenses.wtfpl;
    maintainers = with maintainers; [ jocelynthode ];
  };
}
