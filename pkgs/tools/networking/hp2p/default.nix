{ lib, stdenv, fetchFromGitHub, mpi, python3Packages, autoconf, automake } :

stdenv.mkDerivation rec {
  pname = "hp2p";
  version = "unstable-2023-10-25";

  src = fetchFromGitHub {
    owner = "cea-hpc";
    repo = "hp2p";
    rev = "711f6cc5b4e552d969c2436ad77afd35d31bfd05";
    sha256 = "sha256-mBTJZb3DPmIlL7N+PfjlWmBw0WfFF2DesImVZlbDQKc=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoconf automake python3Packages.wrapPython ];
  buildInputs = [ mpi ] ++ (with python3Packages; [ python plotly ]) ;
  pythonPath = (with python3Packages; [ plotly ]) ;

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
    description = "MPI based benchmark for network diagnostics";
    homepage = "https://github.com/cea-hpc/hp2p";
    platforms = platforms.unix;
    license = licenses.cecill-c;
    maintainers = [ maintainers.bzizou ];
  };
}
