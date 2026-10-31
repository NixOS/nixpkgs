{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "shutilwhich";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "shutilwhich";
    tag = finalAttrs.version;
    hash = "sha256-QNbEPJ37vrTIuhxS4NrUaUTH2A87EjBZvhxxg6xk3BU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shutilwhich" ];

  meta = {
    description = "Backport of shutil.which";
    license = lib.licenses.psfl;
    homepage = "https://github.com/mbr/shutilwhich";
    maintainers = with lib.maintainers; [ multun ];
  };
})
