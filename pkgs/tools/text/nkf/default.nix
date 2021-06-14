{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nkf";
  version = "2.1.5";

  src = fetchurl {
    url = "mirror://osdn/nkf/70406/${pname}-${version}.tar.gz";
    sha256 = "0i5dbcb9aipwr8ym4mhvgf1in3frl6y8h8x96cprz9s7b11xz9yi";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Tool for converting encoding of Japanese text";
    homepage = "https://nkf.osdn.jp/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.auntie ];
  };
}
