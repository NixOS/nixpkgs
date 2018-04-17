{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, libpcap, libnfnetlink, libnetfilter_queue }:

buildGoPackage rec {
  name = "bettercap-${version}";
  version = "2.4";

  goPackagePath = "github.com/bettercap/bettercap";

  src = fetchFromGitHub {
    owner = "bettercap";
    repo = "bettercap";
    rev = "v${version}";
    sha256 = "1k1ank8z9sr3vxm86dfcrn1y3qa3gfwyb2z0fvkvi38gc88pfljb";
  };

  buildInputs = [libpcap libnfnetlink libnetfilter_queue pkgconfig];

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic in realtime, sniff for credentials and much more.
    '' ;
    homepage = https://www.bettercap.org/;
    license = with licenses; gpl3;
    maintainers = with maintainers; [ y0no ];
    platforms = platforms.all;
  };
}
