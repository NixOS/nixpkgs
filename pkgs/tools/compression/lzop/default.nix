{ lib, stdenv, fetchurl, lzo, lzop, testVersion }:

stdenv.mkDerivation rec {
  pname = "lzop";
  version = "1.04";

  src = fetchurl {
    url = "https://www.lzop.org/download/lzop-${version}.tar.gz";
    sha256 = "0h9gb8q7y54m9mvy3jvsmxf21yx8fc3ylzh418hgbbv0i8mbcwky";
  };

  buildInputs = [ lzo ];

  passthru.tests.version = testVersion { package = lzop; };

  meta = with lib; {
    homepage = "http://www.lzop.org";
    description = "Fast file compressor";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
