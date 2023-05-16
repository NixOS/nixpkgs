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
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "0.23.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uT8nSsC8QstjbyO5Ve2jSug3Bd/DuUNoGzquDPVl++o=";
  };

  cargoHash = "sha256-rxQKU73ANokxLb42u3Zom+5Wbv/ayiQJaM9NsTWW8fU=";
=======
    hash = "sha256-PB7EZMJ9wXVneLTc8wiZVxeyE/XybuwUvcVkN6q04lo=";
  };

  cargoHash = "sha256-SxQSzY31m3eTDO38jRpvzwmV9d6puIZ3DwBlC2Zb4b0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    "git"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
=======
  # remove cargo config so it can find the linker on aarch64-unknown-linux-gnu
  postPatch = ''
    rm .cargo/config
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A tool for installing rust binaries as an alternative to building from source";
    homepage = "https://github.com/cargo-bins/cargo-binstall";
    changelog = "https://github.com/cargo-bins/cargo-binstall/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
