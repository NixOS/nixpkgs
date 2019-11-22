{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, libpcap, libnfnetlink, libnetfilter_queue, libusb1 }:

buildGoPackage rec {
  pname = "bettercap";
  version = "2.26.1";

  goPackagePath = "github.com/bettercap/bettercap";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "10qsknyzfpzfpm4gp98jwvw6qmkmx23nw88sbnpl2rlr725l560c";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpcap libnfnetlink libnetfilter_queue libusb1 ];

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
