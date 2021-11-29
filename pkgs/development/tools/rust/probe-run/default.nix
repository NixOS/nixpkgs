{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qlpvy62wqc8k9sww6pbiqv0yrjwpnai1vgrijw5285qpvrdsdw2";
  };

  cargoSha256 = "10ybgzvv2iy5bjmmw48gmgvsx6rfqclsysyfbhd820dg2lshgi44";

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
