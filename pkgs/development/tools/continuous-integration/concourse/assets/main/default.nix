{
  cacert,
  callPackage,
  elmPackages,
  gmp,
  gnused,
  lib,
  nodePackages,
  nss,
  patchelf,
  pkgs,
  src,
  stdenv,
  zlib,
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
  offline-cache = (callPackage ./yarn.nix {}).offline_cache;
in
stdenv.mkDerivation {
  name = "concourse-main-assets";
  nativeBuildInputs = [
    gnused
    nodePackages.uglify-js
    nodePackages.yarn
    patchelf
  ];
  inherit src;
  buildPhase = ''
    mkdir -p elm_home
    export HOME=`realpath elm_home`
    yarn config set yarn-offline-mirror ${offline-cache}
    sed -i -E '/resolved /{s|https://registry.yarnpkg.com/||;s|[@/:-]|_|g}' yarn.lock
    yarn install --offline --frozen-lockfile
    yarn run build-less
    uglifyjs < ${elm-package}/Main.js > web/public/elm.min.js
  '';
  installPhase = ''
    mkdir -p $out
    cp -R ./web/public $out/
  '';
}
