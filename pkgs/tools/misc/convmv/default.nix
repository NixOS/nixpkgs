{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "convmv-1.15";

  src = fetchurl {
    url = "http://www.j3e.de/linux/convmv/${name}.tar.gz";
    sha256 = "0daiiapsrca8zlbmlz2kw2fn4vmkh48cblb70h08idchhk3sw5f3";
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
    platforms = platforms.linux ++ platforms.freebsd ++ platforms.cygwin;
    maintainers = [ maintainers.urkud ];
  };
}
