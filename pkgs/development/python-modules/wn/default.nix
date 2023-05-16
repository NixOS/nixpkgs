{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, flit-core
, requests
, tomli
}:

buildPythonPackage rec {
  pname = "wn";
<<<<<<< HEAD
  version = "0.9.4";
=======
  version = "0.9.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-n03hFoGMAqLu57gw52tY2jkE8uuLFAbwTZ63sHG2168=";
=======
    hash = "sha256-rqrzGUiF1XQZzE6xicwJ7CJsI7SvWlFT4nDCrhtQUWg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    requests
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "wn"
  ];

  meta = with lib; {
    description = "A modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    changelog = "https://github.com/goodmami/wn/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
