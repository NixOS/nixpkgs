{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tls-parser";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = "tls_parser";
    tag = version;
    hash = "sha256-nNQ5XLsZMUXmsTnaqiUeaaHtiVc5r4woRxeYVhO3ICY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tls_parser" ];

  meta = with lib; {
    description = "Small library to parse TLS records";
    homepage = "https://github.com/nabla-c0d3/tls_parser";
    changelog = "https://github.com/nabla-c0d3/tls_parser/releases/tag/${src.tag}";
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
