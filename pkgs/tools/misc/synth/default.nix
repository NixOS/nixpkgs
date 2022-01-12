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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "getsynth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MeZ5bkOMTJVvaBfGahKsXvaYhfMKcYzPFsBp/p2dPQQ=";
  };

  cargoSha256 = "sha256-lNeDpUla/PfGd/AogdcOtrmL1Jp+0Ji9LH1CF7uOEe0=";

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
