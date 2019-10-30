{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "11kjxa39mqdd9jh969ibxd0nlp9bacj2fm4cj6sk4gp6xf7gv90h";
  };

  cargoSha256 = "1888bvkpalfcw9bc9zmf9bmil6x35l9ia31x6mx1h2dvrfpw3bb1";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A syntax-highlighting pager for git";
    homepage = https://github.com/dandavison/delta;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
