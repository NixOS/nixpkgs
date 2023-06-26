{ lib, stdenv, buildNpmPackage, fetchFromGitHub, vscode }:

buildNpmPackage rec {
  pname = "vscode-langservers-extracted";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "hrsh7th";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RLRDEHfEJ2ckn0HTMu0WbMK/o9W20Xwm+XI6kCq57u8=";
  };

  npmDepsHash = "sha256-QhiSj/DigsI4Bfwmk3wG4lDQOWuDDduc/sfJlXiEoGE=";

  postPatch = ''
    # TODO: Add vscode-eslint as a dependency
    # Eliminate the vscode-eslint bin
    sed -i '/^\s*"vscode-eslint-language-server":.*bin\//d' package.json package-lock.json
  '';

  buildPhase =
    let
      extensions =
        if stdenv.isDarwin
        then "${vscode}/Applications/Visual\\ Studio\\ Code.app/Contents/Resources/app/extensions"
        else "${vscode}/lib/vscode/resources/app/extensions";
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
      mv lib/markdown-language-server/node/workerMain.js lib/markdown-language-server/node/main.js
    '';

  meta = with lib; {
    description = "HTML/CSS/JSON/ESLint language servers extracted from vscode.";
    homepage = "https://github.com/hrsh7th/vscode-langservers-extracted";
    license = licenses.mit;
    maintainers = with maintainers; [ lord-valen ];
  };
}
