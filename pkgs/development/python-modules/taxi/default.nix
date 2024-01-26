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
  version = "6.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sephii";
    repo = "taxi";
    rev = version;
    hash = "sha256-wtLlO/W+39kTPjb2U6c54bxWxAQB7CxGxBh8gur+RCQ=";
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
