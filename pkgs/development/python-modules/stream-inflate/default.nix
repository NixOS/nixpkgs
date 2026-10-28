{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  nix-update-script,
  pyprojectVersionPatchHook,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "stream-inflate";
  version = "0.0.43";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "michalc";
    repo = "stream-inflate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GWO262lMKk5RlMvW4SaTk1WCQZjP7ZzTzMMvOXyEtfU=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "stream_inflate" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Uncompress Deflate and Deflate64 streams";
    homepage = "https://github.com/michalc/stream-inflate";
    changelog = "https://github.com/michalc/stream-inflate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
