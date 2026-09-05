{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  rdkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "selfies";
  version = "2.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "the-matter-lab";
    repo = "selfies";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XYMzMhu/lzgmk2ek2Wd8T6hCPK/cfTTim+Al+nxMuaE=";
  };

  build-system = [ setuptools ];

  dependencies = [ ];

  nativeCheckInputs = [
    pytestCheckHook
    rdkit
  ];

  pythonImportsCheck = [ "selfies" ];

  meta = {
    description = "Robust representation of semantically constrained graphs, in particular for molecules in chemistry";
    homepage = "https://github.com/the-matter-lab/selfies";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chemonke ];
  };
})
