{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
, pytz
, requests
, yarl
}:

buildPythonPackage rec {
  pname = "transmission-rpc";
  version = "4.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Trim21";
    repo = "transmission-rpc";
    rev = "refs/tags/v${version}";
    hash = "sha256-GF2dXvtYgXTjdcellyCPFFTjp4Y6PKb2ihQETfomgU4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pydantic
    requests
  ];

  nativeCheckInputs = [
    pytz
    pytestCheckHook
    yarl
  ];

  pythonImportsCheck = [
    "transmission_rpc"
  ];

  disabledTests = [
    # Tests require a running Transmission instance
    "test_real"
  ];

  meta = with lib; {
    description = "Python module that implements the Transmission bittorent client RPC protocol";
    homepage = "https://github.com/Trim21/transmission-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
