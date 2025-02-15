{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  CoreServices,
  Security,
  libiconv,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.54";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R4t1mzXX95rVbEuHvoAnxxEYt7XYg+Bmr8Mh4LIhnMs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-oNWjU/KxvnKipChHPxKDxO5ZKw/44XAG3twQiZ1Lr8I=";

  nativeBuildInputs = [ pkg-config ];

  # TODO figure out how to use provided curl instead of compiling curl from curl-sys
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreServices
      Security
      libiconv
      SystemConfiguration
    ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [
      b4dm4n
      matthiasbeyer
    ];
    mainProgram = "cargo-udeps";
  };
}
