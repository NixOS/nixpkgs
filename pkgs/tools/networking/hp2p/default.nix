{ lib, stdenv, fetchFromGitHub, mpi, python3Packages, autoconf, automake } :

stdenv.mkDerivation rec {
  pname = "hp2p";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "cea-hpc";
    repo = "hp2p";
    rev = version;
    sha256 = "0zvlwb941rlp3vrf9yzv7njgpj3mh4671ch7qvxfa4hq2ivd52br";
  };

  patches = [ ./python3.patch ];
  enableParallelBuilding = true;
  nativeBuildInputs = [ autoconf automake python3Packages.wrapPython ];
  buildInputs = [ mpi ] ++ (with python3Packages; [ python numpy matplotlib plotly mpldatacursor ]) ;
  pythonPath = (with python3Packages; [ numpy matplotlib plotly mpldatacursor ]) ;

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
    export CC=mpicc
    export CXX=mpic++
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "A MPI based benchmark for network diagnostics";
    homepage = "https://github.com/cea-hpc/hp2p";
    platforms = platforms.unix;
    license = licenses.cecill-c;
    maintainers = [ maintainers.bzizou ];
  };
}
