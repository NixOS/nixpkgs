{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, CoreServices
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "hop-cli";
  version = "0.2.60";

  src = fetchFromGitHub {
    owner = "hopinc";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-zNAV9WdtRBlCh7Joky5Dl+cw/FpY1m/WJxUoNikmXvQ=";
  };

  cargoHash = "sha256-1QD6mEXRw3NCTBKJyVGK3demLKUdE6smELpvdFSJiWY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices Security SystemConfiguration
  ];

  OPENSSL_NO_VENDOR = 1;

  checkFlags = [
    # This test fails on read-only filesystems
    "--skip=commands::volumes::utils::test::test_parse_target_from_path_like"
  ];

  meta = with lib; {
    mainProgram = "hop";
    description = "Interact with Hop in your terminal";
    homepage = "https://github.com/hopinc/cli";
    changelog = "https://github.com/hopinc/cli/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
