{ stdenv, nodejs }:

args @ { src, deps, ... }:

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
    ${nodejs}/bin/npm --registry http://www.example.com install ${src}    
    runHook postBuild
  '';

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
} // args)
