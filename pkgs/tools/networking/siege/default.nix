{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "siege-3.0.8";

  src = fetchurl {
    url = "http://download.joedog.org/siege/${name}.tar.gz";
    sha256 = "15xj0cl64mzf89i0jknqg37rkrcaqmgs4755l74b4nmp4bky7ddq";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  buildInputs = [ openssl ];

  configureFlags = [ "--with-ssl=${openssl.dev}" ];

  meta = with stdenv.lib; {
    description = "HTTP load tester";
    maintainers = with maintainers; [ ocharles raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
