{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "1p0c4398kwczwvl4krvfdhg1ixp1gj9nmvzqqv2xlmvrw1qsin8w";
  };

  cargoSha256 = "005y92acsn5j490jkp23ny7bsjd9ql1glybmbh4cyc8b15hmy618";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
