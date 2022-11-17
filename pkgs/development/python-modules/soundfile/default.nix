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
    pname = "soundfile";
    inherit version;
    sha256 = "931738a1c93e8684c2d3e1d514ac63440ce827ec783ea0a2d3e4730e3dc58c18";
  };

  postPatch = ''
    substituteInPlace soundfile.py --replace "_find_library('sndfile')" "'${libsndfile.out}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  checkInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ numpy libsndfile cffi ];
  propagatedNativeBuildInputs = [ cffi ];

  # Test fails on aarch64-darwin with `MemoryError`, 53 failed, 31 errors, see
  # https://github.com/bastibe/python-soundfile/issues/331
  doCheck = stdenv.system != "aarch64-darwin";

  meta = {
    description = "An audio library based on libsndfile, CFFI and NumPy";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/bastibe/python-soundfile";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
