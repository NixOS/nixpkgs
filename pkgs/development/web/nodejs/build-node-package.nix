{ stdenv, runCommand, nodejs, neededNatives}:

args @ { name, src, deps ? [], peerDependencies ? [], flags ? [], ... }:

with stdenv.lib;

let
  npmFlags = concatStringsSep " " (map (v: "--${v}") flags);

  sources = runCommand "node-sources" {} ''
    tar xf ${nodejs.src}
    mv *node* $out
  '';

  peerDeps = listToAttrs (concatMap (dep: map (name: {
    inherit name;
    value = dep;
  }) (filter (nm: !(elem nm (args.passthru.names or []))) dep.names)) (peerDependencies));
in
stdenv.mkDerivation ({
  unpackPhase = "true";

  inherit src;

  configurePhase = ''
    runHook preConfigure
    mkdir node_modules
    ${concatStrings (concatMap (dep: map (name: ''
      ln -sv ${dep}/lib/node_modules/${name} node_modules/
    '') dep.names) deps)}
    ${concatStrings (mapAttrsToList (name: dep: ''
      ln -sv ${dep}/lib/node_modules/${name} node_modules/
    '') peerDeps)}
    export HOME=$(pwd)
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    npm --registry http://www.example.com --nodedir=${sources} install $src ${npmFlags}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules
    ${concatStrings (map (name: ''
      mv node_modules/${name} $out/lib/node_modules
      rm -fR $out/lib/node_modules/${name}/node_modules
      ln -sv $out/.dependent-node-modules $out/lib/node_modules/${name}/node_modules
      if [ -e "$out/lib/node_modules/${name}/man" ]; then
        mkdir -p $out/share
        for dir in "$out/lib/node_modules/${name}/man/"*; do
          mkdir -p $out/share/man/$(basename "$dir")
          for page in "$dir"/*; do
            ln -sv $page $out/share/man/$(basename "$dir")
          done
        done
      fi
    '') args.passthru.names)}
    ${concatStrings (mapAttrsToList (name: dep: ''
      mv node_modules/${name} $out/lib/node_modules
    '') peerDeps)}
    mv node_modules/.bin $out/lib/node_modules 2>/dev/null || true
    mv node_modules $out/.dependent-node-modules
    if [ -d "$out/lib/node_modules/.bin" ]; then
      ln -sv $out/lib/node_modules/.bin $out/bin
      node=`type -p node`
      coffee=`type -p coffee || true`
      find -L $out/lib/node_modules/.bin/* -type f -print0 | \
        xargs -0 sed --follow-symlinks -i \
          -e 's@#!/usr/bin/env node@#!'"$node"'@' \
          -e 's@#!/usr/bin/env coffee@#!'"$coffee"'@' \
          -e 's@#!/.*/node@#!'"$node"'@' \
          -e 's@#!/.*/coffee@#!'"$coffee"'@'
    fi
    runHook postInstall
  '';

  preFixup = concatStringsSep "\n" (map (src: ''
    find $out -type f -print0 | xargs -0 sed -i 's|${src}|${src.name}|g'
  '') src);
} // args // {
  # Run the node setup hook when this package is a build input
  propagatedNativeBuildInputs = (args.propagatedNativeBuildInputs or []) ++ [ nodejs ];

  # Make buildNodePackage useful with --run-env
  nativeBuildInputs = (args.nativeBuildInputs or []) ++ deps ++ peerDependencies ++ neededNatives;
} )
