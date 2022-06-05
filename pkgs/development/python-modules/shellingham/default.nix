{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.4.0";
  format = "pyproject";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = version;
    sha256 = "0f686ym3ywjffis5jfqkhsshjgii64060hajysczflhffrjn9jcp";
  };

  checkInputs = [
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
