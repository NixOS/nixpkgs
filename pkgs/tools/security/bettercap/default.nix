{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, libpcap
, libnfnetlink
, libnetfilter_queue
, libusb1
}:

buildGoModule rec {
  pname = "bettercap";
  version = "2.27.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0jb78c3s6p210mj28qg4aacd8ly6d6k5h9c48y88vmcyllzjvbhl";
  };

  vendorSha256 = "1j272w0zdndcz4fmh9fzbk2q8wmyfi70vn0p6d8cg0r0l231sbyx";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpcap libnfnetlink libnetfilter_queue libusb1 ];

  meta = with lib; {
    description = "A man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
    license = with licenses; gpl3;
    maintainers = with maintainers; [ y0no ];
    platforms = platforms.all;
  };
}