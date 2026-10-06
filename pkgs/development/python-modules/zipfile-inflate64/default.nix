{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  setuptools,
  setuptools-scm,
  inflate64,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "zipfile-inflate64";
  version = "0.2";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "miurahr";
    repo = "zipfile-inflate64";
    tag = "v${finalAttrs.version}";
    # test fixtures are stored in git-lfs
    fetchLFS = true;
    hash = "sha256-Q1nRi3Kcmy8seE+DpxkCGHtYSz7Hw1dQSZKxv1eltYg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ inflate64 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zipfile_inflate64" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extract Enhanced Deflate ZIP archives with Python's zipfile API";
    homepage = "https://codeberg.org/miurahr/zipfile-inflate64";
    changelog = "https://zipfile-inflate64.readthedocs.io/en/latest/changelog.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ denzonl ];
  };
})
