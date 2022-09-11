{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, AppKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "synth";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-siAm6Uq8Y+RexNrkL7nTw/f/v0LkUgqTUhAtJiy9QnE=";
  };

  cargoSha256 = "sha256-COy8szsYKEzjtRBH8063ug5BkMv3qpc3i2RNb+n4I04=";

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    Security
  ];

  checkFlags = [
    # https://github.com/shuttle-hq/synth/issues/309
    "--skip=docs_blog_2021_08_31_seeding_databases_tutorial_dot_md"
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
