{ stdenv, fetchFromGitHub, openssl, perl, pkgconfig, rustPlatform
, CoreServices, Security
}:

rustPlatform.buildRustPackage rec {
  name = "cargo-web-${version}";
  version = "0.6.23";

  src = fetchFromGitHub {
    owner = "koute";
    repo = "cargo-web";
    rev = version;
    sha256 = "1qbi3z4x39il07xlhfvq5ckzjqrf0yf6p8qidf24fp92gb940zxr";
  };

  cargoSha256 = "16wzgyn3k0yn70y0ciliyx1sjgppmkv9b4bn9p4x0qi6l0ah7fdp";

  nativeBuildInputs = [ openssl perl pkgconfig ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with stdenv.lib; {
    description = "A Cargo subcommand for the client-side Web";
    homepage = https://github.com/koute/cargo-web;
    license = with licenses; [asl20 /* or */ mit];
    maintainers = [ maintainers.kevincox ];
    broken = stdenv.isDarwin;  # test with CoreFoundation 10.11
    platforms = platforms.all;
  };
}
