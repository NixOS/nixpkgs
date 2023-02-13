{ lib
, pythonOlder
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tls-parser";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = "tls_parser";
    rev = version;
    hash = "sha256-A1lYRe1sHDoOFdF20DP+xRMcPBWzokIXFphIpaBmwBc=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tls_parser"
  ];

  meta = with lib; {
    description = "Small library to parse TLS records";
    homepage = "https://github.com/nabla-c0d3/tls_parser";
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
