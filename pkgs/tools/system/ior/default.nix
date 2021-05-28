{ stdenv, fetchFromGitHub, openmpi, perl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "ior";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = pname;
    rev = version;
    sha256 = "036cg75c5vq6kijfv8f918vpm9sf1h7lyg6xr9fba7n0dwbbmycv";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openmpi perl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://ior.readthedocs.io/en/latest/";
    description = "Parallel file system I/O performance test";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bzizou ];
  };
}
