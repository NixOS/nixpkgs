{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, numpy
, libsndfile
, cffi
, isPyPy
, stdenv
}:

buildPythonPackage rec {
  pname = "soundfile";
  version = "0.12.1";
  # https://github.com/bastibe/python-soundfile/issues/157
  disabled = isPyPy || stdenv.isi686;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6OEBeyzx3adnrvGdL9nuXr4H4FDUMPd6Cnxmugi4za4=";
  };

  patches = [
    ./0001-Fix-build-on-linux-arm64.patch
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
