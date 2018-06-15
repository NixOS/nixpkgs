{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "stricat-${version}";
  version = "20140609100300";

  src = fetchurl {
    url    = "http://www.stribob.com/dist/${name}.tgz";
    sha256 = "1axg8r4g5n5kdqj5013pgck80nni3z172xkg506vz4zx1zcmrm4r";
  };

  buildFlags = [ "CC=cc" ];

  installPhase = ''
    mkdir -p $out/bin
    mv stricat $out/bin
  '';

  meta = {
    description = "Multi-use cryptographic tool based on the STRIBOB algorithm";
    homepage    = "https://www.stribob.com/stricat/";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
