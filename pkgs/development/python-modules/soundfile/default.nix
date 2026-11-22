{
  lib,
  stdenv,
  buildPythonPackage,
  cffi,
  fetchPypi,
  isPyPy,
  libsndfile,
  numpy,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "soundfile";
  version = "0.14.0";
  pyproject = true;
  disabled = isPyPy;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uhwaLWGLylxAZkfIO4nwfMiBD6UGpQYippk7oTDB3hE=";
  };

  postPatch = ''
    substituteInPlace soundfile.py \
      --replace "_find_library('sndfile')" "'${libsndfile.out}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  build-system = [
    cffi
    setuptools
  ];

  dependencies = [
    cffi
    numpy
    typing-extensions
  ];

  pythonImportsCheck = [ "soundfile" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Audio library based on libsndfile, CFFI and NumPy";
    homepage = "https://github.com/bastibe/python-soundfile";
    changelog = "https://github.com/bastibe/python-soundfile/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    # https://github.com/bastibe/python-soundfile/issues/157
    broken = stdenv.hostPlatform.isi686;
  };
})
