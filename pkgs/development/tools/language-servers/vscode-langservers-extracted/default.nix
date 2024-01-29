{ lib, stdenv, buildNpmPackage, fetchFromGitHub, vscodium, vscode-extensions }:

buildNpmPackage rec {
  pname = "vscode-langservers-extracted";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "hrsh7th";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sGnxmEQ0J74zNbhRpsgF/cYoXwn4jh9yBVjk6UiUdK0=";
  };

  npmDepsHash = "sha256-LFWC87Ahvjf2moijayFze1Jk0TmTc7rOUd/s489PHro=";

  buildPhase =
    let
      extensions =
        if stdenv.isDarwin
        then "${vscodium}/Applications/VSCodium.app/Contents/Resources/app/extensions"
        else "${vscodium}/lib/vscode/resources/app/extensions";
    in
    ''
      npx babel ${extensions}/css-language-features/server/dist/node \
        --out-dir lib/css-language-server/node/
      npx babel ${extensions}/html-language-features/server/dist/node \
        --out-dir lib/html-language-server/node/
      npx babel ${extensions}/json-language-features/server/dist/node \
        --out-dir lib/json-language-server/node/
      npx babel ${extensions}/markdown-language-features/server/dist/node \
        --out-dir lib/markdown-language-server/node/
      cp -r ${vscode-extensions.dbaeumer.vscode-eslint}/share/vscode/extensions/dbaeumer.vscode-eslint/server/out \
        lib/eslint-language-server
      mv lib/markdown-language-server/node/workerMain.js lib/markdown-language-server/node/main.js
    '';

  meta = with lib; {
    description = "HTML/CSS/JSON/ESLint language servers extracted from vscode";
    homepage = "https://github.com/hrsh7th/vscode-langservers-extracted";
    license = licenses.mit;
    maintainers = with maintainers; [ lord-valen ];
  };
}
