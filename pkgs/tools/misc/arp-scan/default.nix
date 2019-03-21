{ stdenv, fetchFromGitHub, autoreconfHook, libpcap, makeWrapper, perlPackages }:

stdenv.mkDerivation rec {
  name = "arp-scan-${version}";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "royhills";
    repo = "arp-scan";
    rev = "4de863c2627a05177eda7159692a588f9f520cd1";
    sha256 = "15zpfdybk2kh98shqs8qqd0f9nyi2ch2wcyv729rfj7yp0hif5mb";
  };

  perlModules = with perlPackages; [
    HTTPDate
    HTTPMessage
    LWP
    URI
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpcap makeWrapper ];

  postInstall = ''
    for name in get-{oui,iab}; do
      wrapProgram "$out/bin/$name" --set PERL5LIB "${perlPackages.makePerlPath perlModules }"
    done;
  '';

  meta = with stdenv.lib; {
    description = "ARP scanning and fingerprinting tool";
    longDescription = ''
      Arp-scan is a command-line tool that uses the ARP protocol to discover
      and fingerprint IP hosts on the local network.
    '';
    homepage = http://www.nta-monitor.com/wiki/index.php/Arp-scan_Documentation;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor mikoim ];
  };
}
