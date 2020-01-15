{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  pname = "htpdate";

  src = fetchurl {
    url = "http://www.vervest.org/htp/archive/c/${pname}-${version}.tar.xz";
    sha256 = "1gqw3lg4wwkn8snf4pf21s3qidhb4h791f2ci7i7i0d6kd86jv0q";
  };

  makeFlags = [
    "INSTALL=install"
    "STRIP=${stdenv.cc.bintools.targetPrefix}strip"
    "prefix=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = http://www.vervest.org/htp/;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
