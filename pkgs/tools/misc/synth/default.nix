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
  version = "0.6.5-r1";

  src = fetchFromGitHub {
    owner = "getsynth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AcAZjS2Wo0PRngf0eYrduEd6rZX5YpYxsWEp0wf9jvg=";
  };

  cargoSha256 = "sha256-mMGlUCvbXaO0XfMwVtpq7HENoSaXrQU7GSh7/OhYdus=";

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
