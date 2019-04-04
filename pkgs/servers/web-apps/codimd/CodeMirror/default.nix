{ stdenv, pkgs, buildEnv, fetchFromGitHub, nodejs-8_x, phantomjs2, which }:

let
  nodePackages = import ./node.nix {
    inherit pkgs;
    system = stdenv.system;
  };

  phantomjs-prebuilt = nodePackages."phantomjs-prebuilt-^2.1.12".override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ phantomjs2 ];
  });
in

stdenv.mkDerivation {
  name = "codemirror-hackmdio-05-07-2018";

  src = fetchFromGitHub {
    owner = "hackmdio";
    repo = "CodeMirror";
    rev = "df412731ed3923124f9a43f60e84bdf855eb843a";
    sha256 = "02v2wccv9sjdda9x45ib8d08i1pc4b8kwg3p6qc314wqq89nhniw";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ nodejs-8_x phantomjs-prebuilt ] ++ (stdenv.lib.attrVals [
    "blint-^1"
    "node-static-0.6.0"
    "rollup-^0.41.0"
    "rollup-plugin-buble-^0.15.0"
    "rollup-watch-^3.2.0"
    "uglify-js-^2.8.15"
  ] nodePackages);

  buildPhase = ''
    patchShebangs .
    npm run build
    node release
  '';

  installPhase = ''
    mkdir -p $out/lib/node_modules/codemirror
    cp -R {codemirror.min.js,addon,bin,keymap,lib,mode,theme} $out/lib/node_modules/codemirror/
    ln -s ${nodePackages."url-loader-^0.5.7"}/lib/node_modules/url-loader \
      $out/lib/node_modules
  '';
}
