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
  version = "2.27";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "18hwz9m16pxlb7wp78iqmdi0kimrx3h05fs0zhzm8qhzancq8alf";
  };

  modSha256 = "1qhmrjb3fvw6maxrl7hb3bizrw6szhwx6s2g59p5pj3dz4x8jajn";

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
