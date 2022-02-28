{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mt-st";
  version = "1.4";

  src = fetchurl {
    url = "https://github.com/iustin/mt-st/releases/download/v${version}/mt-st-${version}.tar.gz";
    sha256 = "f98a4ff02a00f2588ea370bb9560484bf48eb841e2c80a382fc0cd8f1d9a2b4c";
  };

  installFlags = [ "PREFIX=$(out)" "EXEC_PREFIX=$(out)" ];

  meta = {
    description = "Magnetic Tape control tools for Linux";
    longDescription = ''
      Fork of the standard "mt" tool with additional Linux-specific IOCTLs.
    '';
    homepage = "https://github.com/iustin/mt-st";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.redvers ];
    platforms = lib.platforms.linux;
  };
}
