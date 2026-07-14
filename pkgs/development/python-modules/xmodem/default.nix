{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  which,
  lrzsz,
}:

buildPythonPackage (finalAttrs: {
  pname = "xmodem";
  version = "0.4.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tehmaze";
    repo = "xmodem";
    tag = finalAttrs.version;
    hash = "sha256-kwPA/lYiv6IJSKGRuH13tBofZwp19vebwQniHK7A/i8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest
    which
    lrzsz
  ];

  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "xmodem" ];

  meta = {
    description = "Pure python implementation of the XMODEM protocol";
    maintainers = with lib.maintainers; [ emantor ];
    homepage = "https://github.com/tehmaze/xmodem";
    license = lib.licenses.mit;
  };
})
