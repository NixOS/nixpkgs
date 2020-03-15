{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "1q6dqh8z6mhiksjrhi602cvq31jgc18pfbwf6mlm9gi1grpgm5dl";
  };

  cargoSha256 = "1krsr4a1f5rdba4l0i90yr5s8k8hg1np9n85ingx37gar9ahr1y3";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
