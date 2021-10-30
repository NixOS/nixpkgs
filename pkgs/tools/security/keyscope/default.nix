{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, DiskArbitration
, Foundation
, IOKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "keyscope";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "spectralops";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4ZKIukxeadzGpq2lwxbyyIKqWgbZpdHPRAT+LsyWjzk=";
  };

  cargoSha256 = "sha256-aq7xUma8QDRnu74R7JSuZjrXCco7L9JrNmAZiGtTyts=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    DiskArbitration
    Foundation
    IOKit
    Security
  ];

  # build script tries to get information from git
  postPatch = ''
    echo "fn main() {}" > build.rs
  '';

  VERGEN_GIT_SEMVER = "v${version}";

  meta = with lib; {
    description = "A key and secret workflow (validation, invalidation, etc.) tool";
    homepage = "https://github.com/spectralops/keyscope";
    changelog = "https://github.com/spectralops/keyscope/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
