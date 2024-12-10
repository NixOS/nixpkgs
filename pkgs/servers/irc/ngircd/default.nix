{
  lib,
  stdenv,
  fetchurl,
  zlib,
  openssl,
  pam,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "ngircd";
  version = "27";

  src = fetchurl {
    url = "https://ngircd.barton.de/pub/ngircd/${pname}-${version}.tar.xz";
    sha256 = "sha256-aJeIAxndXi5zwckBlhNQn4jrW42qWCGjb7yj14XCR7g=";
  };

  configureFlags = [
    "--with-syslog"
    "--with-zlib"
    "--with-pam"
    "--with-openssl"
    "--enable-ipv6"
    "--with-iconv"
  ];

  buildInputs = [
    zlib
    pam
    openssl
    libiconv
  ];

  meta = {
    description = "Next Generation IRC Daemon";
    mainProgram = "ngircd";
    homepage = "https://ngircd.barton.de";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
}
