{
  callPackage,
  elmPackages,
  lib,
  nodePackages,
  src,
  stdenv,
  symlinkJoin,
}:
let
  mkElmPackage =
    { srcs ? ./elm-srcs.nix
    , src
    , name
    , srcdir ? "./src"
    , targets ? []
    , versionsDat ? ./versions.dat
    }:
    stdenv.mkDerivation {
      inherit name src;

      buildInputs = [ elmPackages.elm ];

      buildPhase = elmPackages.fetchElmDeps {
        elmPackages = import srcs;
        inherit versionsDat;
      };

      installPhase = let
        elmfile = module: "${srcdir}/${builtins.replaceStrings ["."] ["/"] module}.elm";
      in ''
        mkdir -p $out/share/doc
        ${lib.concatStrings (map (module: ''
          echo "compiling ${elmfile module}"
          elm make ${elmfile module} --output $out/${module}.js
        '') targets)}
      '';
    };

  elm-package = mkElmPackage {
    src = src + "/web/elm";
    name = "concourse-web";
    targets = [ "Main" ];
  };
in
stdenv.mkDerivation {
  name = "concourse-main-assets";
  nativeBuildInputs = [
    nodePackages.less
    nodePackages.uglify-js
  ];
  inherit src;
  buildPhase = ''
    export NODE_PATH=${nodePackages.less-plugin-clean-css}/lib/node_modules
    lessc --clean-css=--advanced web/assets/css/main.less web/public/main.css
    uglifyjs < ${elm-package}/Main.js > web/public/elm.min.js
  '';
  installPhase = ''
    mkdir -p $out
    cp -R ./web/public $out/
  '';
}
