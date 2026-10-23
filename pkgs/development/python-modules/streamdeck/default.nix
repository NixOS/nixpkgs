{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  replaceVars,
  pkgs,
}:

buildPythonPackage (finalAttrs: {
  pname = "streamdeck";
  version = "0.9.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "streamdeck";
    inherit (finalAttrs) version;
    hash = "sha256-rO5K0gekDUzCJW06TCK59ZHjw5DvvlFeQ5zlGLMdASU=";
  };

  patches = [
    # substitute libusb path
    (replaceVars ./hardcode-libusb.patch {
      libusb = "${pkgs.hidapi}/lib/libhidapi-libusb${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "StreamDeck" ];
  doCheck = false;

  meta = {
    description = "Python library to control the Elgato Stream Deck";
    homepage = "https://github.com/abcminiuser/python-elgato-streamdeck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ majiir ];
  };
})
