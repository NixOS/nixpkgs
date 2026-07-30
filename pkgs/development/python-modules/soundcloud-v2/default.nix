{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dacite,
  python-dateutil,
  curl-cffi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "soundcloud-v2";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "7x11x13";
    repo = "soundcloud.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Mb7Dt5TYAI/xTMezSWE9klP4Psw59gTEy1448O7CIw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dacite
    python-dateutil
    curl-cffi
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
