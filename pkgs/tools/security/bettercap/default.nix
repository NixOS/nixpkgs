{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, libpcap, libnfnetlink, libnetfilter_queue, libusb1 }:

buildGoPackage rec {
  pname = "bettercap";
  version = "2.24";

  goPackagePath = "github.com/bettercap/bettercap";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1f8bzxbcyf0bpyqj6hz4l8dp5xknnb537xy9y5skcznp03i44h55";
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
