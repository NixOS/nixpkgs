{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "avaGBIKldr+1Zwq+7NOHt2wldmY/6Lb6bi9uVHZFI5Q=";
  };

  cargoSha256 = "HmDKfb8F6sGnaX64FR3No2GbBYm4bVopbjs8d35WiZQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ]
    ++ lib.optionals stdenv.isDarwin [ libiconv AppKit IOKit ];

  meta = with lib; {
    description = "Run embedded programs just like native ones.";
    homepage = "https://github.com/knurling-rs/probe-run";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}
