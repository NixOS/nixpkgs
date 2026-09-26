{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  numpy,
  libsndfile,
  cffi,
  isPyPy,
  stdenv,
}:

buildPythonPackage rec {
  pname = "soundfile";
  version = "0.13.1";
  pyproject = true;
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ssaNqx4wKXMXCApbQ99X4wJYTEnilC3v3eCszMU/Dls=";
  };

  postPatch = ''
    substituteInPlace soundfile.py --replace "_find_library('sndfile')" "'${libsndfile.out}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  build-system = [
    setuptools
    cffi
  ];

  dependencies = [
    numpy
    cffi
  ];

  pythonImportsCheck = [ "soundfile" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Audio library based on libsndfile, CFFI and NumPy";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/bastibe/python-soundfile";
    # https://github.com/bastibe/python-soundfile/issues/157
    broken = stdenv.hostPlatform.isi686;
  };
}
