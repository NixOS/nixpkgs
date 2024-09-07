{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pdf";
  version = "0.1.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zRoO84ij7zF1I8ijXS/oApMKfS3e04+5/CgahAemqCA=";
  };

  cargoHash = "sha256-eay3tl4edeM05D+0iIu8Zw4L1N2Bk1csLo0AwNdyCdA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  # Stop downloading from the Internet to
  # generate the Chrome Devtools Protocol
  env.DOCS_RS = true;

  # Stop formatting with rustfmt
  env.DO_NOT_FORMAT = true;

  # No test.
  doCheck = false;

  meta = with lib; {
    description = "Backend for mdBook written in Rust for generating PDF";
    mainProgram = "mdbook-pdf";
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    changelog = "https://github.com/HollowMan6/mdbook-pdf/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 matthiasbeyer ];
  };
}
