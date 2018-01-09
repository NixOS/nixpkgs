{ stdenv, fetchFromGitHub, perl, gettext, pkgconfig, libidn2 }:

stdenv.mkDerivation rec {
  version = "5.2.20";
  name = "whois-${version}";

  src = fetchFromGitHub {
    owner = "rfc1036";
    repo = "whois";
    rev = "v${version}";
    sha256 = "1aamasivfnghr9my1j6c1rf0dfal45axjcjf3mpv0g942bkxqp5b";
  };

  nativeBuildInputs = [ perl gettext pkgconfig ];
  buildInputs = [ libidn2 ];

  preConfigure = ''
    for i in Makefile po/Makefile; do
      substituteInPlace $i --replace "prefix = /usr" "prefix = $out"
    done
  '';

  buildPhase = "make whois";

  installPhase = "make install-whois";

  meta = with stdenv.lib; {
    description = "Intelligent WHOIS client from Debian";
    longDescription = ''
      This package provides a commandline client for the WHOIS (RFC 3912)
      protocol, which queries online servers for information such as contact
      details for domains and IP address assignments. It can intelligently
      select the appropriate WHOIS server for most queries.
    '';

    homepage = https://packages.qa.debian.org/w/whois.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
