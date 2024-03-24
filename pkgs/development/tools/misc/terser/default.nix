{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.29.2";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-VGQ/mgMeeNA0koYgmb6PAZqBdVljgqY3MwuG0RLllCU=";
  };

  npmDepsHash = "sha256-8wKvV3vSzF6WdHzox1LXVi2FmeZf7qSo2rg93uCN3fI=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
