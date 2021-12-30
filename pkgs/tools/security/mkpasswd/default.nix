{ lib, stdenv, whois, libxcrypt, perl, pkg-config, mkpasswd, testVersion }:

stdenv.mkDerivation {
  pname = "mkpasswd";
  inherit (whois) version src;

  nativeBuildInputs = [ perl pkg-config ];
  buildInputs = [ libxcrypt ];

  inherit (whois) preConfigure;
  buildPhase = "make mkpasswd";
  installPhase = "make install-mkpasswd";

  passthru.tests.version = testVersion { package = mkpasswd; };

  meta = with lib; {
    homepage = "https://packages.qa.debian.org/w/whois.html";
    description = "Overfeatured front-end to crypt, from the Debian whois package";
    license = licenses.gpl2;
    maintainers = with maintainers; [ cstrahan fpletz ];
    platforms = platforms.linux;
  };
}
