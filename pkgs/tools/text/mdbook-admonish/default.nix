{ lib, stdenv, fetchCrate, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-GH4T7arBabm+DXIJa3seP6L13DBleoNqYwzxhoCZJgI=";
  };

  cargoSha256 = "sha256-v0usxkGWs/qzUPU6ZwtTpUD7hXdSBZGYQifMZnr7sfI=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
