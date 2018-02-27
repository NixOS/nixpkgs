{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "convmv-2.04";

  src = fetchurl {
    url = "http://www.j3e.de/linux/convmv/${name}.tar.gz";
    sha256 = "075xn1ill26hbhg4nl54sp75b55db3ikl7lvhqb9ijvkpi67j6yy";
  };

  preBuild=''
    makeFlags="PREFIX=$out"
  '';

  patchPhase=''
    tar -xf testsuite.tar
    patchShebangs .
  '';

  doCheck = true;
  checkTarget = "test";

  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "Converts filenames from one encoding to another";
    platforms = platforms.linux ++ platforms.freebsd ++ platforms.cygwin;
    maintainers = [ ];
  };
}
