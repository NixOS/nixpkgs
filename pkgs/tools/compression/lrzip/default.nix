{stdenv, fetchurl, zlib, lzo, bzip2, nasm, perl}:

let
  md5fix = fetchurl {
    url = "https://github.com/ckolivas/lrzip/commit/9430b6ff4a58adb69ef4cf74f1245fd5b3b313dd.patch";
    sha256 = "084x4wi3mamcxphzwf43iw287v1ylrk0xjghg6b5k6vgm9gkqlx8";
  };
in
stdenv.mkDerivation rec {
  name = "lrzip-0.612";

  src = fetchurl {
    url = "http://ck.kolivas.org/apps/lrzip/${name}.tar.bz2";
    sha256 = "15rfqpc4xj7wbv117mr2g9npxnrlmqqj97mhxqfpy8360ys9yc1c";
  };

  buildInputs = [ zlib lzo bzip2 nasm perl ];

  patches = [ md5fix ];

  meta = {
    homepage = http://ck.kolivas.org/apps/lrzip/;
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    license = "GPLv2+";
  };
}
