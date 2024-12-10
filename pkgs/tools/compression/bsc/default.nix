{
  lib,
  stdenv,
  fetchFromGitHub,
  openmp,
}:

stdenv.mkDerivation rec {
  pname = "bsc";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "IlyaGrebnov";
    repo = "libbsc";
    rev = version;
    sha256 = "0c0jmirh9y23kyi1jnrm13sa3xsjn54jazfr84ag45pai279fciz";
  };

  enableParallelBuilding = true;

  buildInputs = lib.optional stdenv.isDarwin openmp;

  postPatch = ''
    substituteInPlace makefile \
        --replace 'g++' '$(CXX)'
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "High performance block-sorting data compression library";
    homepage = "http://libbsc.com/";
    maintainers = with maintainers; [ ];
    # Later commits changed the licence to Apache2 (no release yet, though)
    license = with licenses; [ lgpl3Plus ];
    platforms = platforms.unix;
    mainProgram = "bsc";
  };
}
