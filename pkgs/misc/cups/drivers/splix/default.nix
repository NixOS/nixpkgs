{stdenv, fetchurl, cups, zlib}:

stdenv.mkDerivation rec {
  name = "splix-2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/splix/${name}.tar.bz2";
    sha256 = "0bwivrwwvh6hzvnycpzqs7a0capgycahc4s3v9ihx552fgy07xwp";
  };

  preBuild=''
    makeFlags="V=1 DISABLE_JBIG=1 CUPSFILTER=$out/lib/cups/filter CUPSPPD=$out/share/cups/model"
  '';

  buildInputs = [cups zlib];

  meta = {
    homepage = http://splix.sourceforge.net;
  };
}
