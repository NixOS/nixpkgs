{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, libiconv, rust }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.8.0";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g24msswk03w1m4hf73v09nf1m4sx3ym8jzf0c685bip530l3db5";
  };

  cargoSha256 = "1w16xfavdfkz0rgddhpmb0ml17s4zh4mcvlldf5gqsz54by25ap9";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ];

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
