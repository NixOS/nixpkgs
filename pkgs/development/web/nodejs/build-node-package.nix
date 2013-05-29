{ stdenv, runCommand, nodejs, neededNatives}:

args @ { src, deps ? [], flags ? [], ... }:

with stdenv.lib;

let npmFlags = concatStringsSep " " (map (v: "--${v}") flags);
    sources = runCommand "node-sources" {} ''
      tar xf ${nodejs.src}
      mv *node* $out
    '';

in
stdenv.mkDerivation ({
  unpackPhase = "true";

  configurePhase = ''
    runHook preConfigure
    mkdir node_modules
    ${stdenv.lib.concatStrings (map (dep: ''
      ln -sv ${dep}/node_modules/${(builtins.parseDrvName dep.name).name} node_modules/
    '') deps)}
    export HOME=$(pwd)
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    npm --registry http://www.example.com --nodedir=${sources} install ${src} ${npmFlags}
    runHook postBuild
  '';

  nativeBuildInputs = neededNatives;

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv node_modules $out
    if [ -d "$out/node_modules/.bin" ]; then
      ln -sv node_modules/.bin $out/bin
      find -L $out/node_modules/.bin/* -type f -print0 | \
        xargs -0 sed --follow-symlinks -i 's@#!/usr/bin/env node@#!${nodejs}/bin/node@'
    fi
    runHook postInstall
  '';

  preFixup = ''
    find $out -type f -print0 | xargs -0 sed -i 's|${src}|${src.name}|g'
  '';
} // args // {
  # Run the node setup hook when this package is a build input
  propagatedNativeBuildInputs = (args.propagatedNativeBuildInputs or []) ++ [ nodejs ];

  # Make buildNodePackage useful with --run-env
  nativeBuildInputs = (args.nativeBuildInputs or []) ++ deps;
} )
