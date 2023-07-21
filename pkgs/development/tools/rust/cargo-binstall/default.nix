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
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    rev = "v${version}";
    hash = "sha256-fwxiqUCdWEf6tjL4z92aN7zrwIXGz6OgXwPcEXd3x4k=";
  };

  cargoHash = "sha256-uBUl5oileUANyKJeoEtBtDSMHZM7e6I4r/0sVelNCeg=";

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
    "git"
    "pkg-config"
    "rustls"
    "trust-dns"
    "zstd-thin"
  ];

  cargoBuildFlags = [ "-p" "cargo-binstall" ];
  cargoTestFlags = [ "-p" "cargo-binstall" ];

  checkFlags = [
    # requires internet access
    "--skip=download::test::test_and_extract"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_no_such_release"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_v0_20_1"
  ];

  meta = with lib; {
    description = "A tool for installing rust binaries as an alternative to building from source";
    homepage = "https://github.com/cargo-bins/cargo-binstall";
    changelog = "https://github.com/cargo-bins/cargo-binstall/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
