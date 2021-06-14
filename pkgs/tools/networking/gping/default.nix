{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "v${version}";
    sha256 = "sha256-lApm1JLXNjDKLj6zj25OaZDVp7lLW3qyrDsvJrudl8I=";
  };

  cargoSha256 = "sha256-d1NjPwT3YDp1U9JWeUejpWDbJonFlt5lYbUf7p3jVT0=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
