{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "convmv-1.14";

  src = fetchurl {
    url = "http://www.j3e.de/linux/convmv/${name}.tar.gz";
    sha256 = "1vvwrbys5kkfpn6kvn0sj3hls5v03d6gr7j7d5phbj8p9bigb5cn";
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
    platforms = platforms.all;
    maintainers = [ maintainers.urkud ];
  };
}
