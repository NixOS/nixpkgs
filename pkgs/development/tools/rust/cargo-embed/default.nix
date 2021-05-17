{ lib
, rustPlatform, fetchFromGitHub
, libusb1, libftdi1, pkg-config, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-embed";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z8n883cb4jca3phi9x2kwl01xclyr00l8jxgiyd28l2jik78i5k";
  };

  cargoSha256 = "1ir9qngxmja6cm42m40jqbga9mlfjllm23ca26wyigjv3025pi6i";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 libftdi1 ];

  cargoBuildFlags = [ "--features=ftdi" ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker ];
  };
}
