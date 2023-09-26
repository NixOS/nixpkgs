{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U9boL+Ki4szDwhdPBvXA5iXYjL9LEMVyez8DX35i5gI=";
  };

  cargoHash = "sha256-cqzY6z4e3ZAVG5HOxkTKYEcAxXu4OsUjpP6SD/LIX74=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman Frostman ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
