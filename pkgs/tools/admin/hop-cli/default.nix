{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hop-cli";
  version = "0.2.52";

  src = fetchFromGitHub {
    owner = "hopinc";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-xuOkW5jetl+8obeFJnbkVZa+wYWfTNiTOmcrzC8+wGE=";
  };

  cargoHash = "sha256-ePUlw4UzsQ2lNuJ5g5OAYh6nKTIoHdDMb34Jzuqtas8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices Security
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
