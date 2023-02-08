{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytestCheckHook
, numpy
, libsndfile
, cffi
, isPyPy
, stdenv
}:

buildPythonPackage rec {
  pname = "soundfile";
  version = "0.11.0";
  # https://github.com/bastibe/python-soundfile/issues/157
  disabled = isPyPy || stdenv.isi686;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kxc4ock+hoTC0+HVFKxjRAzoJ+x4PqCi0+RzDj3FjBg=";
  };

  patches = [
    # Fix arch detection on darwin, https://github.com/bastibe/python-soundfile/pull/365
    (fetchpatch {
      url = "https://github.com/bastibe/python-soundfile/commit/0bf248c72aee4781b2b8aafad46b5f51488be2c4.patch";
      sha256 = "sha256-dPY8buf9rF3aB6ZkNDDV1rl1UuARFmSix9uY0MBRZ40=";
    })
  ];

  postPatch = ''
    substituteInPlace soundfile.py --replace "_find_library('sndfile')" "'${libsndfile.out}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  nativeCheckInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ numpy libsndfile cffi ];
  propagatedNativeBuildInputs = [ cffi ];

  meta = {
    description = "An audio library based on libsndfile, CFFI and NumPy";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/bastibe/python-soundfile";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
