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

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0k3fla0zz2r66y5fvmbcdhjd2jq8md2sxgcjb3x8sipzqfv8bwi2";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
