{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, AppKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "synth";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "getsynth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TtIZwGHSfY7Xz6hmrsmaB7dXfjSPcBD4yDyC27TJ4B4=";
  };

  cargoSha256 = "sha256-V5GA5XR3wkcBdbxRjO8PkF7Q3yg1NVUjXsdAHVip4Bc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Security
  ];

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "A tool for generating realistic data using a declarative data model";
    homepage = "https://github.com/getsynth/synth";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
