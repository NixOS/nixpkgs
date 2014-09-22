{ stdenv, runCommand, nodejs, neededNatives}:

args @ { name, src, deps ? {}, peerDependencies ? [], flags ? [], preShellHook ? "",  postShellHook ? "", resolvedDeps ? {}, bin ? null, ... }:

with stdenv.lib;

let
  npmFlags = concatStringsSep " " (map (v: "--${v}") flags);

  sources = runCommand "node-sources" {} ''
    tar --no-same-owner --no-same-permissions -xf ${nodejs.src}
    mv *node* $out
  '';

  # Convert deps to attribute set
  attrDeps = if isAttrs deps then deps else
    (listToAttrs (map (dep: nameValuePair dep.name dep) deps));

  # All required node modules, without already resolved dependencies
  requiredDeps = removeAttrs attrDeps (attrNames resolvedDeps);

  # Recursive dependencies that we want to avoid with shim creation
  recursiveDeps = removeAttrs attrDeps (attrNames requiredDeps);

  peerDeps = listToAttrs (concatMap (dep: map (name: {
    inherit name;
    value = dep;
  }) (filter (nm: !(elem nm (args.passthru.names or []))) dep.names)) (peerDependencies));

  self = let
    # Pass resolved dependencies to dependencies of this package 
    deps = map (
      dep: dep.override {
        resolvedDeps = resolvedDeps // { "${name}" = self; };
      }
    ) (attrValues requiredDeps);

  in stdenv.mkDerivation ({
    unpackPhase = "true";

    inherit src;
    
    configurePhase = ''
      runHook preConfigure
      mkdir node_modules

      # Symlink dependencies for node modules
      ${concatStrings (concatMap (dep: map (name: ''
        ln -sv ${dep}/lib/node_modules/${name} node_modules/
      '') dep.names) deps)}

      # Symlink peer dependencies
      ${concatStrings (mapAttrsToList (name: dep: ''
        ln -sv ${dep}/lib/node_modules/${name} node_modules/
      '') peerDeps)}

      # Create shims for recursive dependenceies
      ${concatStrings (concatMap (dep: map (name: ''
        mkdir -p node_modules/${name}
        cat > node_modules/${name}/package.json <<EOF
        {
            "name": "${name}",
            "version": "${(builtins.parseDrvName dep.name).version}"
        }
        EOF
      '') dep.names) (attrValues recursiveDeps))}

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

      # Remove shims
      ${concatStrings (concatMap (dep: map (name: ''
        rm  node_modules/${name}/package.json
        rmdir node_modules/${name}
      '') dep.names) (attrValues recursiveDeps))}

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

    shellHook = ''
      ${preShellHook}
      export PATH=${nodejs}/bin:$(pwd)/node_modules/.bin:$PATH
      mkdir -p node_modules
      ${concatStrings (concatMap (dep: map (name: ''
        ln -sfv ${dep}/lib/node_modules/${name} node_modules/
      '') dep.names) deps)}
      ${postShellHook}
    '';
  } // (filterAttrs (n: v: n != "deps" && n != "resolvedDeps") args) // {
    name = "${
      if bin == true then "bin-" else if bin == false then "node-" else ""
    }${name}";

    # Run the node setup hook when this package is a build input
    propagatedNativeBuildInputs = (args.propagatedNativeBuildInputs or []) ++ [ nodejs ];

    # Make buildNodePackage useful with --run-env
    nativeBuildInputs = (args.nativeBuildInputs or []) ++ deps ++ peerDependencies ++ neededNatives;
  });

in self
