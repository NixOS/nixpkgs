{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y5tnY8EZJcVhYyVTpvcT6DFbPSmmw3+knzkMVvQxQbI=";
  };

  cargoHash = "sha256-X8wQvLSvZ7rrDfX423SDB5QDDMoeDDFvJZKO92CLycg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
    ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = with lib; {
    description = "Utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    changelog = "https://github.com/killercup/cargo-edit/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      Br1ght0ne
      figsoda
      gerschtli
      jb55
      killercup
    ];
  };
}
