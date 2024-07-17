{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libpcap,
  libnfnetlink,
  libnetfilter_queue,
  libusb1,
}:

buildGoModule rec {
  pname = "bettercap";
  version = "2.32.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OND8WPqU/95rKykqMAPWmDsJ+AjsjGjrncZ2/m3mpt0=";
  };

  vendorHash = "sha256-QKv8F9QLRi+1Bqj9KywJsTErjs7o6gFM4tJLA8y52MY=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      libpcap
      libusb1
    ]
    ++ lib.optionals stdenv.isLinux [
      libnfnetlink
      libnetfilter_queue
    ];

  meta = with lib; {
    description = "Man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various
      types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic
      in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ y0no ];
    mainProgram = "bettercap";
  };
}
