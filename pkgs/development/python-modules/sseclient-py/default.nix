{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sseclient-py";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mpetazzoni";
    repo = "sseclient";
    rev = "sseclient-py-${version}";
    hash = "sha256-rNiJqR7/e+Rhi6kVBY8gZJZczqSUsyszotXkb4OKfWk=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sseclient"
  ];

  pytestFlagsArray = [
    "tests/unittests.py"
  ];

  meta = with lib; {
    description = "Pure-Python Server Side Events (SSE) client";
    homepage = "https://github.com/mpetazzoni/sseclient";
    changelog = "https://github.com/mpetazzoni/sseclient/releases/tag/sseclient-py-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
