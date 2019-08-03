{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, libsndfile
, cffi
, isPyPy
, stdenv
}:

buildPythonPackage rec {
  pname = "soundfile";
  version = "0.10.2";

  src = fetchPypi {
    pname = "SoundFile";
    inherit version;
    sha256 = "0w8mjadairg6av88090kwsridd0k115672b91zlcmf37r0c64zv3";
  };

    checkInputs = [ pytest ];
    propagatedBuildInputs = [ numpy libsndfile cffi ];

    meta = {
      description = "An audio library based on libsndfile, CFFI and NumPy";
      license = lib.licenses.bsd3;
      homepage = https://github.com/bastibe/PySoundFile;
      maintainers = with lib.maintainers; [ fridh ];
    };

    postPatch = ''
      substituteInPlace soundfile.py --replace "_find_library('sndfile')" "'${libsndfile.out}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}'"
    '';

    # https://github.com/bastibe/PySoundFile/issues/157
    disabled = isPyPy ||  stdenv.isi686;

}
