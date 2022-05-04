{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, libusb1, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-rs-cli";
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-XYrB/aKuFCe0FNe6N9vqDdr408tAiN6YvT5BL6lCxmU=";
  };

  cargoSha256 = "sha256-aXSJMSGNl2fzob1j/qiPHHZLisYQeU1gUO5cYbzSHYA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "CLI tool for on-chip debugging and flashing of ARM chips";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ xgroleau ];
  };
}
