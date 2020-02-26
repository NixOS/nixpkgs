{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libiconv, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    # This is the git commit that produced 0.9.5, according to crates.io, but
    # the tag is missing in git. See here for details:
    # https://github.com/kbknapp/cargo-outdated/issues/206
    rev = "7685da3265749bb7ae2b436a132f51d19b409bff";
    sha256 = "08prksns7d3g7ha601z8p28p36rg44rjl5ph76vg6nriww96zzca";
  };

  cargoSha256 = "0kxfavyd9slpp2kzxhjp47q1pzw9rlmn7yhxnjsg88sxbjxfzv95";

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
