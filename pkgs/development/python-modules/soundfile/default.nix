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

  postPatch = ''
    substituteInPlace soundfile.py --replace "_find_library('sndfile')" "'${libsndfile.out}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  nativeCheckInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ numpy libsndfile cffi ];
  propagatedNativeBuildInputs = [ cffi ];

  preConfigure = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    export PYSOUNDFILE_ARCHITECTURE=x86_64
  '';

  meta = {
    description = "An audio library based on libsndfile, CFFI and NumPy";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/bastibe/python-soundfile";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
