{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, rust, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.7.2";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ocibNgH2xw0BrJRmHCAahO6hPLmlDmwjjzo7mMWp9FU=";
  };

  cargoSha256 = "sha256-6ztMEfVOlsyUtIeH+Qd/l7khC7XOHKc4bWsDd27RNu8=";

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
