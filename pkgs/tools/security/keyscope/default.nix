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
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "spectralops";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RKeEumj9HuifEXE8g5G7EsIalGD1vLRawh59s/ykUmg=";
  };

  cargoSha256 = "sha256-8lTwczuOgPhzwGcQ2KoqK5Zf3HS3uwsok036l+12Xb0=";

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
