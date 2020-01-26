{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libiconv, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "02gsarwm4gjkr9m4sfbjwp37xmqhch8qpyy027bxqkg8iyipxm69";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1ywmrvkwwwwh99l4j8vc4cyk8qjd0jx8hn68yr2h31ya1bzcqbd1";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    libiconv
    curl
  ];

  meta = with stdenv.lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = https://github.com/kbknapp/cargo-outdated;
    license = with licenses; [ asl20 /* or */ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ sondr3 ivan ];
  };
}
