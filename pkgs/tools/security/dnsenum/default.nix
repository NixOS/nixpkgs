{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation rec {
  pname = "dnsenum";
  version = "1.2.4.2";

  src = fetchFromGitHub {
    owner = "fwaeytens";
    repo = pname;
    rev = version;
    sha256 = "1bg1ljv6klic13wq4r53bg6inhc74kqwm3w210865b1v1n8wj60v";
  };

  propagatedBuildInputs = with perlPackages; [
    perl
    NetDNS
    NetIP
    NetNetmask
    StringRandom
    XMLWriter
    NetWhoisIP
    WWWMechanize
  ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -vD dnsenum.pl $out/bin/dnsenum
    install -vD dns.txt -t $out/share
  '';

  meta = with lib; {
    homepage = "https://github.com/fwaeytens/dnsenum";
    description = "A tool to enumerate DNS information";
    mainProgram = "dnsenum";
    maintainers = with maintainers; [ c0bw3b ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
