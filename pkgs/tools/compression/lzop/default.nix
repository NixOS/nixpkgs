{stdenv, fetchurl, lzo}:

stdenv.mkDerivation {
  name = "lzop-1.02rc1";
  src = fetchurl {
    url = http://www.lzop.org/download/lzop-1.02rc1.tar.gz;
    sha256 = "1dc32bfd82b130727bcec1de3b8a7cf090b78b3f14981d375ceb862b1e0e6873";
  };

  buildInputs = [ lzo ];

  meta = {
    homepage = http://www.lzop.org;
    description = "Fast file compressor";
    license = "GPL";
  };
}
