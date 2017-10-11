{ stdenv, fetchFromGitHub, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  name = "dnsenum-${version}";
  version = "1.2.4.2";

  src = fetchFromGitHub {
    owner = "fwaeytens";
    repo = "dnsenum";
    rev = version;
    sha256 = "1bg1ljv6klic13wq4r53bg6inhc74kqwm3w210865b1v1n8wj60v";
  };

  propagatedBuildInputs = with perlPackages; [
    perl NetDNS NetIP NetNetmask StringRandom XMLWriter NetWhoisIP WWWMechanize
  ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -vD dnsenum.pl $out/bin/dnsenum
    install -vD dns.txt -t $out/share
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/fwaeytens/dnsenum;
    description = "A tool to enumerate DNS information";
    maintainers = [ maintainers.globin ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
