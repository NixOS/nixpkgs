{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.29.1";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-1E5sXNKekkxv40FwGBR20LEWbM63SyKOZ7h1pcCqLKA=";
  };

  npmDepsHash = "sha256-X37hDDyi0eEWdVoy3vU6+efXgEaLRK81LjfDEWqSFC0=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
