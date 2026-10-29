{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  braceexpand,
  inform,
}:

buildPythonPackage (finalAttrs: {
  pname = "shlib";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "shlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ymX5Vz4QYrKX9GTsQMWtdLM4z0KtaSfZp0iTkCb/8aI=";
  };

  postPatch = ''
    patchShebangs .
  '';

  build-system = [ flit-core ];

  dependencies = [
    braceexpand
    inform
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shlib" ];

  meta = {
    description = "Shell library";
    homepage = "https://github.com/KenKundert/shlib";
    changelog = "https://github.com/KenKundert/shlib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
})
