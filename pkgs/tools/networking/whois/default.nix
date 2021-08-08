{ lib, stdenv, fetchFromGitHub, perl, gettext, pkg-config, libidn2, libiconv }:

stdenv.mkDerivation rec {
  version = "5.5.10";
  pname = "whois";

  src = fetchFromGitHub {
    owner = "rfc1036";
    repo = "whois";
    rev = "v${version}";
    sha256 = "179hgmh9yqk8jq26ybik4cr3lgryd5p6kdwccc3r7mfssk3yp8lz";
  };

  nativeBuildInputs = [ perl gettext pkg-config ];
  buildInputs = [ libidn2 libiconv ];

  preConfigure = ''
    for i in Makefile po/Makefile; do
      substituteInPlace $i --replace "prefix = /usr" "prefix = $out"
    done
  '';

  makeFlags = [ "HAVE_ICONV=1" ];
  buildFlags = [ "whois" ];

  installTargets = [ "install-whois" ];

  meta = with lib; {
    description = "Intelligent WHOIS client from Debian";
    longDescription = ''
      This package provides a commandline client for the WHOIS (RFC 3912)
      protocol, which queries online servers for information such as contact
      details for domains and IP address assignments. It can intelligently
      select the appropriate WHOIS server for most queries.
    '';

    homepage = "https://packages.qa.debian.org/w/whois.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
