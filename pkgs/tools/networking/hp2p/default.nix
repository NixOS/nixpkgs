{ stdenv, fetchFromGitHub, mpi, python2Packages, autoconf, automake } :

stdenv.mkDerivation rec {
  pname = "hp2p";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "cea-hpc";
    repo = "hp2p";
    rev = "${version}";
    sha256 = "0zvlwb941rlp3vrf9yzv7njgpj3mh4671ch7qvxfa4hq2ivd52br";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoconf automake python2Packages.wrapPython ];
  buildInputs = [ openmpi ] ++ (with python2Packages; [ python numpy matplotlib plotly ]) ;
  pythonPath = (with python2Packages; [ numpy matplotlib plotly ]) ;

  preConfigure = ''
    patchShebangs .
    ./autogen.sh
    export CC=mpicc
    export CXX=mpic++
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "A MPI based benchmark for network diagnostics";
    homepage = "https://github.com/cea-hpc/hp2p";
    platforms = platforms.unix;
    license = licenses.cecill-c;
    maintainers = [ maintainers.bzizou ];
  };
}
