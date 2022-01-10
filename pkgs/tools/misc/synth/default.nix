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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "getsynth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/ml94Y0XjJIlSqs+1LagLBxJrQIF4ZEGX75zEr9nU9Y=";
  };

  cargoSha256 = "sha256-P5QFB9CRY9KP0UKQ0utRqtj18s/NFCwmghHzzpixEbs=";

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
