{
  lib,
  aiosendspin-mpris,
  aiosendspin,
  av,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pulsectl-asyncio,
  pychromecast,
  pytestCheckHook,
  qrcode,
  readchar,
  rich,
  setuptools,
  sounddevice,
}:

buildPythonPackage (finalAttrs: {
  pname = "sendspin";
  version = "5.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "sendspin-cli";
    tag = finalAttrs.version;
    hash = "sha256-g+qw3mDHij50CEDKGjltMGNZoI6/HeJQ8zq8NSvD3Ls=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiosendspin
    aiosendspin-mpris
    av
    numpy
    pulsectl-asyncio
    qrcode
    readchar
    rich
    sounddevice
  ];

  optional-dependencies = {
    cast = [ pychromecast ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sendspin" ];

  disabledTests = [
    #  AssertionError: assert None == (1, 'Digital')
    "test_alsa_available_for_hw_device_with_mixer"
    "test_hifiberry_dac_discovery"
  ];

  meta = {
    description = "Synchronized audio player for Sendspin servers";
    homepage = "https://github.com/Sendspin/sendspin-cli";
    changelog = "https://github.com/Sendspin/sendspin-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
