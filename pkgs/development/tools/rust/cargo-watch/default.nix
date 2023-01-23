{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, Foundation, rust, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2keI5hTWglqh+mLeGzRCxpfnUt6kur0I9fefYwZr5l4=";
  };

  cargoHash = "sha256-kR12j0Z7nXfwh9nPT35/LpkK56a8D1gvVkl9/2s6rIQ=";

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
