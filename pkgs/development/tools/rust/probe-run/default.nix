{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1nfbpdx378p988q75hka9r8zp3xb9zy3dnagcxmha6dca5dhgsdm";
  };

  cargoSha256 = "05p3vmar00215x4mwsvs5knf4wrwmpq52rmbbi6b4qaqs3gqaghy";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ]
    ++ lib.optionals stdenv.isDarwin [ libiconv AppKit IOKit ];

  meta = with lib; {
    description = "Run embedded programs just like native ones.";
    homepage = "https://github.com/knurling-rs/probe-run";
    changelog = "https://github.com/knurling-rs/probe-run/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}
