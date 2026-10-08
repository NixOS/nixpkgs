{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "webencodings";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CourtBouillon";
    repo = "webencodings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-45dI6iRLvHsEUwSSLj9uOC96G8lZ27inujpfMiigsxs=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "webencodings" ];

  meta = {
    description = "Character encoding aliases for legacy web content";
    homepage = "https://github.com/CourtBouillon/webencodings";
    changelog = "https://github.com/CourtBouillon/webencodings/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
