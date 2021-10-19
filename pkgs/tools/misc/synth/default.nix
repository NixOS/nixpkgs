{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "synth";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "getsynth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i5X2HUOCgY2znH4rDzhFpsPXsFeM7GR4soAO/rFDjjo=";
  };

  cargoSha256 = "sha256-47i46Y6JjTGWC7mfMd2x2k8v0SY1o2UHdEU4rF0VrsY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "A tool for generating realistic data using a declarative data model";
    homepage = "https://github.com/getsynth/synth";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
