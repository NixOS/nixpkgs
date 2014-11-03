{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "siege-3.0.6";

  src = fetchurl {
    url = "http://www.joedog.org/pub/siege/${name}.tar.gz";
    sha256 = "0nwcj2s804z7yd20pa0cl010m0qgf22a02305i9jwxynwdj9kdvq";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  configureFlags = [ "--with-ssl=${openssl}" ];

  meta = with stdenv.lib; {
    description = "HTTP load tester";
    maintainers = with maintainers; [ ocharles raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
