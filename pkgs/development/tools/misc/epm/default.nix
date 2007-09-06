{stdenv, fetchurl, rpm}:

stdenv.mkDerivation {
  name = "epm-4.1";

  src = fetchurl {
    url = http://ftp.rz.tu-bs.de/pub/mirror/ftp.easysw.com/ftp/pub/epm/4.1/epm-4.1-source.tar.bz2;
    sha256 = "18xq1h9hx410x28bfccabydrqb1c0dqnq62qa17wc3846rwf234n";
  };

  buildInputs = [rpm];

  meta = {
    description = "The ESP Package Manager generates distribution archives for a variety of platforms";
    homepage = http://www.easysw.com/epm/index.php;
  };
}
