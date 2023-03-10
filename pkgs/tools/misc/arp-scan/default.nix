{ lib, stdenv, fetchFromGitHub, autoreconfHook, libpcap, makeWrapper, perlPackages }:

stdenv.mkDerivation rec {
  pname = "arp-scan";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "royhills";
    repo = "arp-scan";
    rev = version;
    sha256 = "sha256-zSihemqGaQ5z6XjA/dALoSJOuAkxF5/nnV6xE+GY7KI=";
  };

  perlModules = with perlPackages; [
    HTTPDate
    HTTPMessage
    LWP
    URI
  ];

  nativeBuildInputs = [ autoreconfHook makeWrapper ];
  buildInputs = [ perlPackages.perl libpcap ];

  postInstall = ''
    for name in get-{oui,iab}; do
      wrapProgram "$out/bin/$name" --set PERL5LIB "${perlPackages.makeFullPerlPath perlModules}"
    done;
  '';

  meta = with lib; {
    description = "ARP scanning and fingerprinting tool";
    longDescription = ''
      Arp-scan is a command-line tool that uses the ARP protocol to discover
      and fingerprint IP hosts on the local network.
    '';
    homepage = "http://www.nta-monitor.com/wiki/index.php/Arp-scan_Documentation";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor mikoim r-burns ];
  };
}
