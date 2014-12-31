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

    patchShebangs = dir: ''
        node=`type -p node`
        coffee=`type -p coffee || true`
        find -L ${dir} -type f -print0 | \
        xargs -0 sed --follow-symlinks -i \
            -e 's@#!/usr/bin/env node@#!'"$node"'@' \
            -e 's@#!/usr/bin/env coffee@#!'"$coffee"'@' \
            -e 's@#!/.*/node@#!'"$node"'@' \
            -e 's@#!/.*/coffee@#!'"$coffee"'@' || true
    '';

  in stdenv.mkDerivation ({
    inherit src;

    postPatch = ''
      ${patchShebangs "./"}

      # Some version specifiers (latest, unstable, URLs, file paths) force NPM
      # to make remote connections or consult paths outside the Nix store.
      # The following JavaScript replaces these by * to prevent that:

      (
      cat <<EOF
        var fs = require('fs');
        var url = require('url');

        /*
        * Replaces an impure version specification by *
        */
        function replaceImpureVersionSpec(versionSpec) {
            var parsedUrl = url.parse(versionSpec);

            if(versionSpec == "latest" || versionSpec == "unstable" ||
                versionSpec.substr(0, 2) == ".." || dependency.substr(0, 2) == "./" || dependency.substr(0, 2) == "~/" || dependency.substr(0, 1) == '/' || /^[^/]+\/[^/]+$/.test(versionSpec))
                return '*';
            else if(parsedUrl.protocol == "git:" || parsedUrl.protocol == "git+ssh:" || parsedUrl.protocol == "git+http:" || parsedUrl.protocol == "git+https:" ||
                parsedUrl.protocol == "http:" || parsedUrl.protocol == "https:")
                return '*';
            else
                return versionSpec;
        }

        var packageObj = JSON.parse(fs.readFileSync('./package.json'));

        /* Replace dependencies */
        if(packageObj.dependencies !== undefined) {
            for(var dependency in packageObj.dependencies) {
                var versionSpec = packageObj.dependencies[dependency];
                packageObj.dependencies[dependency] = replaceImpureVersionSpec(versionSpec);
            }
        }

        /* Replace development dependencies */
        if(packageObj.devDependencies !== undefined) {
            for(var dependency in packageObj.devDependencies) {
                var versionSpec = packageObj.devDependencies[dependency];
                packageObj.devDependencies[dependency] = replaceImpureVersionSpec(versionSpec);
            }
        }

        /* Replace optional dependencies */
        if(packageObj.optionalDependencies !== undefined) {
            for(var dependency in packageObj.optionalDependencies) {
                var versionSpec = packageObj.optionalDependencies[dependency];
                packageObj.optionalDependencies[dependency] = replaceImpureVersionSpec(versionSpec);
            }
        }

        /* Write the fixed JSON file */
        fs.writeFileSync("package.json", JSON.stringify(packageObj));
      EOF
      ) | node
    '';

    configurePhase = ''
      runHook preConfigure

      mkdir build-dir
      (
        cd build-dir
        mkdir node_modules

        # Symlink or copy dependencies for node modules
        # copy is needed if dependency has recursive dependencies,
        # because node can't follow symlinks while resolving recursive deps.
        ${concatStrings (concatMap (dep: map (name:
          if dep.recursiveDeps == [] then ''
            ln -sv ${dep}/lib/node_modules/${name} node_modules/
          '' else ''
            cp -R ${dep}/lib/node_modules/${name} node_modules/
          ''
        ) dep.names) deps)}

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
      )

      export HOME=$PWD/build-dir
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      # If source was a file, repackage it, so npm pre/post publish hooks are not triggered,
      if [[ -f $src ]]; then
        tar --exclude='build-dir' -czf build-dir/package.tgz ./
        export src=$HOME/package.tgz
      else
        export src=$PWD
      fi

      # Install package
      (cd $HOME && npm --registry http://www.example.com --nodedir=${sources} install $src ${npmFlags})

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      (
        cd $HOME

        # Remove shims
        ${concatStrings (concatMap (dep: map (name: ''
          rm node_modules/${name}/package.json
          rmdir node_modules/${name}
        '') dep.names) (attrValues recursiveDeps))}

        mkdir -p $out/lib/node_modules

        # Install manual
        ${concatStrings (map (name: ''
          mv node_modules/${name} $out/lib/node_modules
          rm -fR $out/lib/node_modules/${name}/node_modules
          cp -r node_modules $out/lib/node_modules/${name}/node_modules

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

        # Symlink dependencies
        ${concatStrings (mapAttrsToList (name: dep: ''
          mv node_modules/${name} $out/lib/node_modules
        '') peerDeps)}

        # Install binaries and patch shebangs
        mv node_modules/.bin $out/lib/node_modules 2>/dev/null || true
        if [ -d "$out/lib/node_modules/.bin" ]; then
          ln -sv $out/lib/node_modules/.bin $out/bin
          ${patchShebangs "$out/lib/node_modules/.bin/*"}
        fi
      )

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

    # Expose list of recursive dependencies upstream, up to the package that
    # caused recursive dependency
    recursiveDeps = (flatten (map (d: remove name d.recursiveDeps) deps)) ++ (attrNames recursiveDeps);
  });

in self
