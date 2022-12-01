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
  version = "0.10.3.post1";
  # https://github.com/bastibe/python-soundfile/issues/157
  disabled = isPyPy || stdenv.isi686;

  src = fetchPypi {
    pname = "SoundFile";
    inherit version;
    sha256 = "0yqhrfz7xkvqrwdxdx2ydy4h467sk7z3gf984y1x2cq7cm1gy329";
  };

  patches = [
    # Fix build on macOS arm64, https://github.com/bastibe/python-soundfile/pull/332
    (fetchpatch {
      url = "https://github.com/bastibe/python-soundfile/commit/e554e9ce8bed96207d587e6aa661e4b08f1c6a79.patch";
      sha256 = "sha256-vu/7s5q4I3yBnoNHmmFmcXvOLFcPwY9ri9ri6cKLDwU=";
    })
  ];

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
