{
  lib,
  buildPythonPackage,
  fetchPypi,

  unittestCheckHook,

  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "tinysegmenter";
  version = "0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "tinysegmenter";
    inherit (finalAttrs) version;
    hash = "sha256-ZEWL26VLp0gsAseF+WDPPWz2FZSk2rPWTDJUOQlPwbc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [
    "--start-directory=tests"
  ];

  pythonImportsCheck = [ "tinysegmenter" ];

  meta = {
    description = "Very compact Japanese tokenizer";
    homepage = "https://tinysegmenter.tuxfamily.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vizid ];
  };
})
