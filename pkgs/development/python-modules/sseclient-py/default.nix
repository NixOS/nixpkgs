{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sseclient-py";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mpetazzoni";
    repo = "sseclient";
    tag = "sseclient-py-${version}";
    hash = "sha256-AIldZFElGgSbw38aZWCWI1N35MiE+b9D1s/XhD7aIvo=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sseclient" ];

  meta = {
    description = "Pure-Python Server Side Events (SSE) client";
    homepage = "https://github.com/mpetazzoni/sseclient";
    changelog = "https://github.com/mpetazzoni/sseclient/releases/tag/sseclient-py-${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
