{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "ujson";
  version = "5.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-4gSub5CfCZumtrlCExzuNZ3dorbk6jnBLri5kf4gEOA=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ujson" ];

  meta = {
    description = "Ultra fast JSON encoder and decoder";
    homepage = "https://github.com/ultrajson/ultrajson";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
