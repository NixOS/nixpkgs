{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "integrity-scrub";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "illdefined";
    repo = pname;
    rev = version;
    hash = "sha256-+ntu+1yb6JnqZ6uhueS5puONiE0UkRLJ2vJZqeMrpEE=";
  };

  cargoHash = "sha256-CMkBfK9btt71KV7NJd9zEynz43f3/1/RZMFQbfwrHkA=";

  meta = with lib; {
    homepage = "https://github.com/illdefined/integrity-scrub";
    description = "Scrub dm-integrity devices";
    license = licenses.miros;
    maintainers = with maintainers; [ mvs ];
    platforms = platforms.linux;
  };
}
