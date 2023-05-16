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
<<<<<<< HEAD
  version = "6.2.0";
=======
  version = "6.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sephii";
    repo = "taxi";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-wtLlO/W+39kTPjb2U6c54bxWxAQB7CxGxBh8gur+RCQ=";
=======
    hash = "sha256-iIy3odDX3QzVG80AFp81m8AYKES4JjlDp49GGpuIHLI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
