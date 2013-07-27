{ stdenv, runCommand, nodejs, neededNatives}:

args @ { name, src, deps ? [], flags ? [], ... }:

with stdenv.lib;

let
  npmFlags = concatStringsSep " " (map (v: "--${v}") flags);

  sources = runCommand "node-sources" {} ''
    tar xf ${nodejs.src}
    mv *node* $out
  '';

  requireName = (builtins.parseDrvName name).name;
in
stdenv.mkDerivation ({
  unpackPhase = "true";

  configurePhase = ''
    runHook preConfigure
    mkdir node_modules
    ${stdenv.lib.concatStrings (map (dep: ''
      ln -sv ${dep}/lib/node_modules/${(builtins.parseDrvName dep.name).name} node_modules/
    '') deps)}
    export HOME=$(pwd)
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    npm --registry http://www.example.com --nodedir=${sources} install ${src} ${npmFlags}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules
    mv node_modules/${requireName} $out/lib/node_modules
    mv node_modules/.bin $out/lib/node_modules 2>/dev/null || true
    rm -fR $out/lib/node_modules/${requireName}/node_modules
    mv node_modules $out/lib/node_modules/${requireName}
    if [ -d "$out/lib/node_modules/.bin" ]; then
      ln -sv node_modules/.bin $out/bin
      node=`type -p node`
      coffee=`type -p coffee || true`
      find -L $out/lib/node_modules/.bin/* -type f -print0 | \
        xargs -0 sed --follow-symlinks -i \
          -e 's@#!/usr/bin/env node@#!'"$node"'@' \
          -e 's@#!/usr/bin/env coffee@#!'"$coffee"'@' \
          -e 's@#!/.*/node@#!'"$node"'@' \
          -e 's@#!/.*/coffee@#!'"$coffee"'@'
    fi
    if [ -e "$out/lib/node_modules/${requireName}/man" ]; then
      mkdir $out/share
      ln -sv $out/lib/node_modules/${requireName}/man $out/share/man
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
  nativeBuildInputs = (args.nativeBuildInputs or []) ++ deps ++ neededNatives;
} )
