{ lib, stdenv
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
  version = "2.30";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ge+fbNEWq+84LypUbNrnNMOxcDJb8rFlP/QUoE7yEds=";
  };

  vendorSha256 = "sha256-fApxHxdzEEc+M+U5f0271VgrkXTGkUD75BpDXpVYd5k=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpcap libusb1 ]
    ++ lib.optionals stdenv.isLinux [ libnfnetlink libnetfilter_queue ];

  meta = with lib; {
    description = "A man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
    license = with licenses; gpl3;
    maintainers = with maintainers; [ y0no ];
  };
}
