{ stdenv, fetchFromGitHub, openssl, perl, pkgconfig, rustPlatform
, CoreServices, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-web";
  version = "0.6.25";

  src = fetchFromGitHub {
    owner = "koute";
    repo = pname;
    rev = version;
    sha256 = "0q77bryc7ap8gb4rzp9xk8ngqwxh106qn7899g30lwxycnyii0mf";
  };

  cargoSha256 = "1f4sj260q4rlzbajwimya1yhh90hmmbhr47yfg9i8xcv5cg0cqjn";

  nativeBuildInputs = [ openssl perl pkgconfig ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with stdenv.lib; {
    description = "A Cargo subcommand for the client-side Web";
    homepage = https://github.com/koute/cargo-web;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.kevincox ];
    platforms = platforms.all;
  };
}
