{ lib
, rustPlatform
, fetchFromGitHub
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

  cargoSha256 = "sha256-2PxhtAqROgufVGGH7VtEJJU6Sa2OrGbbMVRUWYbAD0Q=";

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
