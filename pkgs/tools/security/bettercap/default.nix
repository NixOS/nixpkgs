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
  version = "2.31.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vZajnKjuIFoNnjxSsFkkpxyCR27VWqVN4lGf9SadmPU=";
  };

  vendorSha256 = "sha256-et6D+M+xJbxIiDP7JRRABZ8UqUCpt9ZVI5DP45tyTGM=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpcap libusb1 ]
    ++ lib.optionals stdenv.isLinux [ libnfnetlink libnetfilter_queue ];

  meta = with lib; {
    description = "A man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various
      types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic
      in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ y0no ];
  };
}
