{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  binaryornot,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "test2ref";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbiotcloud";
    repo = "test2ref";
    tag = "v${version}";
    hash = "sha256-m95undMr1W2GRcSELv7s9kpuXyu+HnGo+huc0Uh9rQI=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    binaryornot
  ];

  pythonImportsCheck = [ "test2ref" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Testing Against Learned Reference Data";
    homepage = "https://github.com/nbiotcloud/test2ref";
    changelog = "https://github.com/nbiotcloud/test2ref/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
