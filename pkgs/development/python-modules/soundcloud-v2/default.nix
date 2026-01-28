{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dacite,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "soundcloud-v2";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "7x11x13";
    repo = "soundcloud.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xx5F5xscPCbuN7T03zL5V9LLrTbpJnTF4lmUVEqBJA4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dacite
    python-dateutil
    requests
  ];

  # tests require network
  doCheck = false;

  pythonImportsCheck = [ "soundcloud" ];

  meta = {
    description = "Python wrapper for the v2 SoundCloud API";
    homepage = "https://github.com/7x11x13/soundcloud.py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
