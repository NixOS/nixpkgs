{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  moreorless,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "stdlibs";
  version = "2026.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "stdlibs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W2fj+hGZ5UA/XNO0CUyTbz/Wwhh3pr/2qB8Su5TdKPM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "flit_core >=4,<5" "flit_core"
  '';

  build-system = [ flit-core ];

  nativeCheckInputs = [
    moreorless
    unittestCheckHook
  ];

  pythonImportsCheck = [ "stdlibs" ];

  meta = {
    description = "Overview of the Python stdlib";
    homepage = "https://github.com/omnilib/stdlibs";
    changelog = "https://github.com/omnilib/stdlibs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
