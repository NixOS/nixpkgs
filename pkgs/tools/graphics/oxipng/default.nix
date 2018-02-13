{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "1.0.0";
  name = "oxipng-${version}";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    rev = "v${version}";
    sha256 = "1w3y9qy72sfz6zv1iizp843fd39rf1qfh7b9mllbn5w8w4hd658w";
  };

  cargoSha256 = "0mj45svb0nly3cl5d1fmm7nh2zswxpgb56g9xnb4cks5186sn5fi";

  meta = with stdenv.lib; {
    homepage = https://github.com/shssoichiro/oxipng;
    description = "A lossless PNG compression optimizer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
