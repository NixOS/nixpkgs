{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, libusb1, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-rs-cli";
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3aKRUABJ1LkRGzwDSwQZeNXKGeRmTlbHKSGewfKn+2Q=";
  };

  cargoSha256 = "sha256-bOfdpRVm9zqpFF/YmD06u4OKdyqXwfCSTNlTIZZygeg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "CLI tool for on-chip debugging and flashing of ARM chips";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ xgroleau newam ];
  };
}
