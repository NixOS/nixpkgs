{ stdenv, fetchFromGitHub, autoreconfHook, libpcap, makeWrapper, perlPackages }:

stdenv.mkDerivation rec {
  pname = "arp-scan";
  version = "1.9.7";

  src = fetchFromGitHub {
    owner = "royhills";
    repo = "arp-scan";
    rev = version;
    sha256 = "1mf7a4f9vzvnkiavc87aqyciswggsb4fpy7j05jxnvjyyxv3l7gp";
  };

  perlModules = with perlPackages; [
    HTTPDate
    HTTPMessage
    LWP
    URI
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perlPackages.perl libpcap makeWrapper ];

  postInstall = ''
    for name in get-{oui,iab}; do
      wrapProgram "$out/bin/$name" --set PERL5LIB "${perlPackages.makeFullPerlPath perlModules}"
    done;
  '';

  meta = with stdenv.lib; {
    description = "ARP scanning and fingerprinting tool";
    longDescription = ''
      Arp-scan is a command-line tool that uses the ARP protocol to discover
      and fingerprint IP hosts on the local network.
    '';
    homepage = "http://www.nta-monitor.com/wiki/index.php/Arp-scan_Documentation";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor mikoim ];
  };
}
