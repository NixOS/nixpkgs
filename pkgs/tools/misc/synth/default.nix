{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, AppKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "synth";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/z2VEfeCCuffxlMh4WOpYkMSAgmh+sbx3ajcD5d4DdE=";
  };

  cargoSha256 = "sha256-i2Pp9sfTBth3DtrQ99Vw+KLnGECrkqtlRNAKiwSWf48=";

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
    description = "Tool for generating realistic data using a declarative data model";
    homepage = "https://github.com/getsynth/synth";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
