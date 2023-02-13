{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.5.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-CIO5mBFph+5cO7U4NRjMRtQCTbopJDEGlAGBkxjieFw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "shellingham" ];

  meta = with lib; {
    description = "Tool to detect the surrounding shell";
    homepage = "https://github.com/sarugaku/shellingham";
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
