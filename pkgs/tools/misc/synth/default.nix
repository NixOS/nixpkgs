{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # https://github.com/shuttle-hq/synth/pull/391
    (fetchpatch {
      name = "fix-for-rust-1.65.patch";
      url = "https://github.com/shuttle-hq/synth/commit/c69b9b5c72441a51d09fc977de16b09a60eeecd3.patch";
      hash = "sha256-uRCf+rEYTRgYPyrAbcXNEwpB92tzN8oYgv+/TyJaoHo=";
    })
  ];

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
