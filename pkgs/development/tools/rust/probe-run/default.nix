{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-SXA77LXM1SuBJ8BH+ahwJl/3gWsCbdLXBiHZdJySWq0=";
  };

  cargoSha256 = "sha256-e9POSuA/I7IUKUOxMTfCWxNn0AicojpGQpxamzmHa7g=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ]
    ++ lib.optionals stdenv.isDarwin [ libiconv AppKit IOKit ];

  meta = with lib; {
    description = "Run embedded programs just like native ones.";
    homepage = "https://github.com/knurling-rs/probe-run";
    changelog = "https://github.com/knurling-rs/probe-run/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear newam ];
  };
}
