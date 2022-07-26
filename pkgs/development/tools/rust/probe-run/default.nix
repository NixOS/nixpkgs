{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-7o0aRiCxWoDoMysXIPyiBqH/8TtFo87im6Y0OFL0cTA=";
  };

  cargoSha256 = "sha256-vREz3FTZXMrc18LXIycJXX6SgW6IKGIgL/+79dMfNjk=";

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
