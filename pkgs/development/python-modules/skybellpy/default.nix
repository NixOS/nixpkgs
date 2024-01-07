{ lib
, buildPythonPackage
, colorlog
, fetchFromGitHub
, pytest-sugar
, pytest-timeout
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "skybellpy";
  version = "0.6.3";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "MisterWil";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ghvm0pcdyhq6xfjc2dkldd701x77w07077sx09xsk6q2milmvzz";
  };

  propagatedBuildInputs = [
    colorlog
    requests
  ];

  nativeCheckInputs = [
    pytest-sugar
    pytest-timeout
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "skybellpy" ];

  meta = with lib; {
    description = "Python wrapper for the Skybell alarm API";
    homepage = "https://github.com/MisterWil/skybellpy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
