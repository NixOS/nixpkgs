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
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "spectralops";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SLVNzxwZhdK2Fk2Vu5P/j0d8IoUPzlb9e5hnJrZ8Qsk=";
  };

  cargoSha256 = "sha256-PBSQeLQ7UkWhGlRID+bv2HwzgvoiJ120t/TNKJFUY+M=";

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
