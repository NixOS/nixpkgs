{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "keyscope";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "spectralops";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dv559a5al7p8r3l90sky4fx4qsxwxlm0ani8qn75pxb70z22qj5";
  };

  cargoSha256 = "sha256-+6O1EY67MVxWrco7a0QTF7Ls1w9YWwNYjiaEe9ckCkg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

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
