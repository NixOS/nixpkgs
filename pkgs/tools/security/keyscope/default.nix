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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "spectralops";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SrBtgirg52q7gM3GZsJsV8ASACvb4sYv5HDbyItpjbk=";
  };

  cargoSha256 = "sha256-MFP3AqlfaclmZxRwaWFw6hsZwCQMRKJEyFEyUN+QLqo=";

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
    description = "Key and secret workflow (validation, invalidation, etc.) tool";
    mainProgram = "keyscope";
    homepage = "https://github.com/spectralops/keyscope";
    changelog = "https://github.com/spectralops/keyscope/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
