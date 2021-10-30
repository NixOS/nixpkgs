{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, Foundation, rust, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wv1aD20VHar0V7oKOEKIX3klGVXauMXU4vL+NgNeZPk=";
  };

  cargoSha256 = "sha256-qhCDrZAG1FcPYKMj2C/m+5Dplko4Tpp1hGpRdGOK/Ds=";

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
