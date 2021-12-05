{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, AppKit
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "synth";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "getsynth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VsvGrlFmn8Q7dhvo3Buy8G0oeNErtBT4lZ8k8WFC8Zo=";
  };

  cargoSha256 = "sha256-10b2n7wMuBt90GZ6AVnSMT7r2501tounw13eJhyrmS4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ AppKit Security ];

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description =
      "A tool for generating realistic data using a declarative data model";
    homepage = "https://github.com/getsynth/synth";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
