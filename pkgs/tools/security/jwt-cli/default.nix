{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "0pmxis3m3madwnmswz9hn0i8fz6a9bg11slgrrwql7mx23ijqf6y";
  };

  cargoSha256 = "165g1v0c8jxs8ddm8ld0hh7k8mvk3566ig43pf99hnw009fg1yc2";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
