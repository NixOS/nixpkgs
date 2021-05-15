{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, rust, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.8.0";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZbVBwSg3roIMA+5LVP3omtTgbAJ7HAdJDXyAybWuRLw=";
  };

  cargoSha256 = "sha256-6aoi/CLla/yKa5RuVgn8RJ9AK1j1wtZeBn+6tpXrJvA=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  preCheck = ''
    export PATH="$(pwd)/target/${rust.toRustTarget stdenv.hostPlatform}/release:$PATH"
  '';

  meta = with lib; {
    description = "A Cargo subcommand for watching over Cargo project's source";
    homepage = "https://github.com/passcod/cargo-watch";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ivan ];
  };
}
