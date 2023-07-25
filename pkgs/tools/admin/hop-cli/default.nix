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
  version = "0.2.35";

  src = fetchFromGitHub {
    owner = "hopinc";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-TgPEcsv7/n+PzZXazozbgmX2tt4WDvyH3j6rY+M0AGE=";
  };

  cargoHash = "sha256-HEUsyboZQ4j5IEOqiWEBSlJqmaNDHPg1kstnM9AgZBo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices Security
  ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    mainProgram = "hop";
    description = "Interact with Hop in your terminal";
    homepage = "https://github.com/hopinc/cli";
    changelog = "https://github.com/hopinc/cli/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
