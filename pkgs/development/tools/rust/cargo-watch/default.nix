{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, Foundation, rust, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vvr/O0Xk9hmUVUFoOk/MzTlEvR0Spx5n/9lsE2HfkF8=";
  };

  cargoSha256 = "sha256-kX9CE95Z2nLb6VM19bu+UkOZ/hsjHUo/JMu0Y0xont0=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Foundation libiconv ];

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
