{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, xz
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-binstall";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    rev = "v${version}";
    hash = "sha256-K4NerJSW3ckXMFFnFCMXIqMeevE3Xzr/Wsz9nloolBI=";
  };

  cargoHash = "sha256-YSKnfhSZ885evtEK40QTt90RwtH03aO/aJ6A/DddoVU=";

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

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "fancy-no-backtrace"
    "pkg-config"
    "rustls"
    "trust-dns"
    "zstd-thin"
  ];

  checkFlags = [
    # requires internet access
    "--skip=download::test::test_and_extract"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_no_such_release"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_v0_20_1"
  ];

  # remove cargo config so it can find the linker on aarch64-unknown-linux-gnu
  postPatch = ''
    rm .cargo/config
  '';

  meta = with lib; {
    description = "A tool for installing rust binaries as an alternative to building from source";
    homepage = "https://github.com/cargo-bins/cargo-binstall";
    changelog = "https://github.com/cargo-bins/cargo-binstall/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
