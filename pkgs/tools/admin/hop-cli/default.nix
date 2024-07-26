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
  version = "0.2.61";

  src = fetchFromGitHub {
    owner = "hopinc";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-omKLUe4JxF3SN4FHbO6YpIRt97f8wWY3oy7VHfvONRc=";
  };

  cargoHash = "sha256-yZKTVF810v27CnjwocEE2KYtrXggdEFPbKH5/4MMMhQ=";

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
