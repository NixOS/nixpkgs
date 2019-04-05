{
  cacert,
  elmPackages,
  gmp,
  lib,
  mkYarnPackage,
  nodePackages,
  nss,
  patchelf,
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
in
mkYarnPackage {
  name = "concourse-main-assets";
  nativeBuildInputs = [
    cacert
    nodePackages.uglify-js
    nodePackages.yarn
    patchelf
  ];
  buildInputs = [ cacert ];
  inherit src;
  yarnNix = ./yarn.nix;
  yarnFlags = [
    "--offline"
    "--frozen-lockfile"
  ];
  preBuild = ''
    mkdir -p elm_home
    export HOME=`realpath elm_home`
    yarn run build-less
    uglifyjs < ${elm-package}/Main.js > web/public/elm.min.js
  '';
  installPhase = ''
    mkdir -p $out
    cp -R ./web/public $out/
  '';
}
