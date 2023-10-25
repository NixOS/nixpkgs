{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, xz
, zstd
, stdenv
, darwin
, git
, rustup
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dist";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
    hash = "sha256-Y4dCkyOAOQRnaHWMuPTpjgIqlnzYw+sQbTyxp1pO7oo=";
  };

  cargoHash = "sha256-Fuc5lToojwcRbcKrApQ8vxd8ZdjEJTDQULYfzV4K4GA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    xz
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ] ++ lib.optionals stdenv.isDarwin [
    rustup
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # skip tests that assume the rust toolchain is using musl
  checkFlags = [
    "--skip=test_error_manifest"
    "--skip=test_lib_manifest"
    "--skip=test_lib_manifest_slash"
    "--skip=test_manifest"
  ];

  # remove tests that require internet access
  postPatch = ''
    rm cargo-dist/tests/integration-tests.rs
  '';

  meta = with lib; {
    description = "A tool for building final distributable artifacts and uploading them to an archive";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
