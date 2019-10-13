{ pkgs ? import <nixpkgs> {}
, nodejs ? pkgs.nodejs
, yarn ? pkgs.yarn
}:

let
  inherit (pkgs) stdenv lib fetchurl linkFarm callPackage git rsync makeWrapper;

  compose = f: g: x: f (g x);
  id = x: x;
  composeAll = builtins.foldl' compose id;
in rec {
  # Export yarn again to make it easier to find out which yarn was used.
  inherit yarn;

  # Re-export pkgs
  inherit pkgs;

  unlessNull = item: alt:
    if item == null then alt else item;

  reformatPackageName = pname:
    let
      # regex adapted from `validate-npm-package-name`
      # will produce 3 parts e.g.
      # "@someorg/somepackage" -> [ "@someorg/" "someorg" "somepackage" ]
      # "somepackage" -> [ null null "somepackage" ]
      parts = builtins.tail (builtins.match "^(@([^/]+)/)?([^/]+)$" pname);
      # if there is no organisation we need to filter out null values.
      non-null = builtins.filter (x: x != null) parts;
    in builtins.concatStringsSep "-" non-null;

  # https://docs.npmjs.com/files/package.json#license
  # TODO: support expression syntax (OR, AND, etc)
  spdxLicense = licstr:
    if licstr == "UNLICENSED" then
      lib.licenses.unfree
    else
      lib.findFirst
        (l: l ? spdxId && l.spdxId == licstr)
        { shortName = licstr; }
        (builtins.attrValues lib.licenses);

  # Generates the yarn.nix from the yarn.lock file
  mkYarnNix = { yarnLock, flags ? [] }:
    pkgs.runCommand "yarn.nix" {}
    "${yarn2nix}/bin/yarn2nix --lockfile ${yarnLock} --no-patch --builtin-fetchgit ${lib.escapeShellArgs flags} > $out";

  # Loads the generated offline cache. This will be used by yarn as
  # the package source.
  importOfflineCache = yarnNix:
    let
      pkg = callPackage yarnNix { };
    in
      pkg.offline_cache;

  defaultYarnFlags = [
    "--offline"
    "--frozen-lockfile"
    "--ignore-engines"
    "--ignore-scripts"
  ];

  mkYarnModules = {
    name, # safe name and version, e.g. testcompany-one-modules-1.0.0
    pname, # original name, e.g @testcompany/one
    version,
    packageJSON,
    yarnLock,
    yarnNix ? mkYarnNix { inherit yarnLock; },
    yarnFlags ? defaultYarnFlags,
    pkgConfig ? {},
    preBuild ? "",
    postBuild ? "",
    workspaceDependencies ? [], # List of yarn packages
  }:
    let
      offlineCache = importOfflineCache yarnNix;

      extraBuildInputs = (lib.flatten (builtins.map (key:
        pkgConfig.${key}.buildInputs or []
      ) (builtins.attrNames pkgConfig)));

      postInstall = (builtins.map (key:
        if (pkgConfig.${key} ? postInstall) then
          ''
            for f in $(find -L -path '*/node_modules/${key}' -type d); do
              (cd "$f" && (${pkgConfig.${key}.postInstall}))
            done
          ''
        else
          ""
      ) (builtins.attrNames pkgConfig));

      workspaceJSON = pkgs.writeText
        "${name}-workspace-package.json"
        (builtins.toJSON { private = true; workspaces = ["deps/**"]; }); # scoped packages need second splat

      workspaceDependencyLinks = lib.concatMapStringsSep "\n"
        (dep: ''
          mkdir -p "deps/${dep.pname}"
          ln -sf ${dep.packageJSON} "deps/${dep.pname}/package.json"
        '')
        workspaceDependencies;

    in stdenv.mkDerivation {
      inherit preBuild postBuild name;
      phases = ["configurePhase" "buildPhase"];
      buildInputs = [ yarn nodejs git ] ++ extraBuildInputs;

      configurePhase = ''
        # Yarn writes cache directories etc to $HOME.
        export HOME=$PWD/yarn_home
      '';

      buildPhase = ''
        runHook preBuild

        mkdir -p "deps/${pname}"
        cp ${packageJSON} "deps/${pname}/package.json"
        cp ${workspaceJSON} ./package.json
        cp ${yarnLock} ./yarn.lock
        chmod +w ./yarn.lock

        yarn config --offline set yarn-offline-mirror ${offlineCache}

        # Do not look up in the registry, but in the offline cache.
        ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock

        ${workspaceDependencyLinks}

        yarn install ${lib.escapeShellArgs yarnFlags}

        ${lib.concatStringsSep "\n" postInstall}

        mkdir $out
        mv node_modules $out/
        mv deps $out/
        patchShebangs $out

        runHook postBuild
      '';
    };

  # This can be used as a shellHook in mkYarnPackage. It brings the built node_modules into
  # the shell-hook environment.
  linkNodeModulesHook = ''
    if [[ -d node_modules || -L node_modules ]]; then
      echo "./node_modules is present. Replacing."
      rm -rf node_modules
    fi

    ln -s "$node_modules" node_modules
  '';

  mkYarnWorkspace = {
    src,
    packageJSON ? src + "/package.json",
    yarnLock ? src + "/yarn.lock",
    packageOverrides ? {},
    ...
  }@attrs:
  let
    package = lib.importJSON packageJSON;

    packageGlobs = package.workspaces;

    globElemToRegex = lib.replaceStrings ["*"] [".*"];

    # PathGlob -> [PathGlobElem]
    splitGlob = lib.splitString "/";

    # Path -> [PathGlobElem] -> [Path]
    # Note: Only directories are included, everything else is filtered out
    expandGlobList = base: globElems:
      let
        elemRegex = globElemToRegex (lib.head globElems);
        rest = lib.tail globElems;
        children = lib.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir base));
        matchingChildren = lib.filter (child: builtins.match elemRegex child != null) children;
      in if globElems == []
        then [ base ]
        else lib.concatMap (child: expandGlobList (base+("/"+child)) rest) matchingChildren;

    # Path -> PathGlob -> [Path]
    expandGlob = base: glob: expandGlobList base (splitGlob glob);

    packagePaths = lib.concatMap (expandGlob src) packageGlobs;

    packages = lib.listToAttrs (map (src:
      let
        packageJSON = src + "/package.json";

        package = lib.importJSON packageJSON;

        allDependencies = lib.foldl (a: b: a // b) {} (map (field: lib.attrByPath [field] {} package) ["dependencies" "devDependencies"]);

        # { [name: String] : { pname : String, packageJSON : String, ... } } -> { [pname: String] : version } -> [{ pname : String, packageJSON : String, ... }]
        getWorkspaceDependencies = packages: allDependencies:
          let
            packageList = lib.attrValues packages;
          in
            composeAll [
              (lib.filter (x: x != null))
              (lib.mapAttrsToList (pname: _version: lib.findFirst (package: package.pname == pname) null packageList))
            ] allDependencies;

        workspaceDependencies = getWorkspaceDependencies packages allDependencies;

        name = reformatPackageName package.name;
      in {
        inherit name;
        value = mkYarnPackage (
          builtins.removeAttrs attrs ["packageOverrides"]
          // { inherit src packageJSON yarnLock workspaceDependencies; }
          // lib.attrByPath [name] {} packageOverrides
        );
      })
      packagePaths
    );
  in packages;

  mkYarnPackage = {
    name ? null,
    src,
    packageJSON ? src + "/package.json",
    yarnLock ? src + "/yarn.lock",
    yarnNix ? mkYarnNix { inherit yarnLock; },
    yarnFlags ? defaultYarnFlags,
    yarnPreBuild ? "",
    pkgConfig ? {},
    extraBuildInputs ? [],
    publishBinsFor ? null,
    workspaceDependencies ? [], # List of yarnPackages
    ...
  }@attrs:
    let
      package = lib.importJSON packageJSON;
      pname = package.name;
      safeName = reformatPackageName pname;
      version = package.version;
      baseName = unlessNull name "${safeName}-${version}";

      workspaceDependenciesTransitive = lib.unique (
        (lib.flatten (builtins.map (dep: dep.workspaceDependencies) workspaceDependencies))
        ++ workspaceDependencies
      );

      deps = mkYarnModules {
        name = "${safeName}-modules-${version}";
        preBuild = yarnPreBuild;
        workspaceDependencies = workspaceDependenciesTransitive;
        inherit packageJSON pname version yarnLock yarnNix yarnFlags pkgConfig;
      };

      publishBinsFor_ = unlessNull publishBinsFor [pname];

      linkDirFunction = ''
        linkDirToDirLinks() {
          target=$1
          if [ ! -f "$target" ]; then
            mkdir -p "$target"
          elif [ -L "$target" ]; then
            local new=$(mktemp -d)
            trueSource=$(realpath "$target")
            if [ "$(ls $trueSource | wc -l)" -gt 0 ]; then
              ln -s $trueSource/* $new/
            fi
            rm -r "$target"
            mv "$new" "$target"
          fi
        }
      '';

      workspaceDependencyCopy = lib.concatMapStringsSep "\n"
        (dep: ''
          # ensure any existing scope directory is not a symlink
          linkDirToDirLinks "$(dirname node_modules/${dep.pname})"
          mkdir -p "deps/${dep.pname}"
          tar -xf "${dep}/tarballs/${dep.name}.tgz" --directory "deps/${dep.pname}" --strip-components=1
          if [ ! -e "deps/${dep.pname}/node_modules" ]; then
            ln -s "${deps}/deps/${dep.pname}/node_modules" "deps/${dep.pname}/node_modules"
          fi
        '')
        workspaceDependenciesTransitive;

    in stdenv.mkDerivation (builtins.removeAttrs attrs ["pkgConfig" "workspaceDependencies"] // {
      inherit src pname;

      name = baseName;

      buildInputs = [ yarn nodejs rsync ] ++ extraBuildInputs;

      node_modules = deps + "/node_modules";

      configurePhase = attrs.configurePhase or ''
        runHook preConfigure

        for localDir in npm-packages-offline-cache node_modules; do
          if [[ -d $localDir || -L $localDir ]]; then
            echo "$localDir dir present. Removing."
            rm -rf $localDir
          fi
        done

        # move convent of . to ./deps/${pname}
        mv $PWD $NIX_BUILD_TOP/temp
        mkdir -p "$PWD/deps/${pname}"
        rm -fd "$PWD/deps/${pname}"
        mv $NIX_BUILD_TOP/temp "$PWD/deps/${pname}"
        cd $PWD

        ln -s ${deps}/deps/${pname}/node_modules "deps/${pname}/node_modules"

        cp -r $node_modules node_modules
        chmod -R +w node_modules

        ${linkDirFunction}

        linkDirToDirLinks "$(dirname node_modules/${pname})"
        ln -s "deps/${pname}" "node_modules/${pname}"

        ${workspaceDependencyCopy}

        # Help yarn commands run in other phases find the package
        echo "--cwd deps/${pname}" > .yarnrc
        runHook postConfigure
      '';

      # Replace this phase on frontend packages where only the generated
      # files are an interesting output.
      installPhase = attrs.installPhase or ''
        runHook preInstall

        mkdir -p $out/{bin,libexec/${pname}}
        mv node_modules $out/libexec/${pname}/node_modules
        mv deps $out/libexec/${pname}/deps

        node ${./internal/fixup_bin.js} $out/bin $out/libexec/${pname}/node_modules ${lib.concatStringsSep " " publishBinsFor_}

        runHook postInstall
      '';

      doDist = true;

      distPhase = attrs.distPhase or ''
        # pack command ignores cwd option
        rm -f .yarnrc
        cd $out/libexec/${pname}/deps/${pname}
        mkdir -p $out/tarballs/
        yarn pack --offline --ignore-scripts --filename $out/tarballs/${baseName}.tgz
      '';

      passthru = {
        inherit pname package packageJSON deps;
        workspaceDependencies = workspaceDependenciesTransitive;
      } // (attrs.passthru or {});

      meta = {
        inherit (nodejs.meta) platforms;
        description = packageJSON.description or "";
        homepage = packageJSON.homepage or "";
        version = packageJSON.version or "";
        license = if packageJSON ? license then spdxLicense packageJSON.license else "";
      } // (attrs.meta or {});
    });

  yarn2nix = mkYarnPackage {
    src =
      let
        src = ./.;

        mkFilter = { dirsToInclude, filesToInclude, root }: path: type:
          let
            inherit (pkgs.lib) any flip elem hasSuffix hasPrefix elemAt splitString;

            subpath = elemAt (splitString "${toString root}/" path) 1;
            spdir = elemAt (splitString "/" subpath) 0;
          in elem spdir dirsToInclude ||
            (type == "regular" && elem subpath filesToInclude);
      in builtins.filterSource
          (mkFilter {
            dirsToInclude = ["bin" "lib"];
            filesToInclude = ["package.json" "yarn.lock"];
            root = src;
          })
          src;

    # yarn2nix is the only package that requires the yarnNix option.
    # All the other projects can auto-generate that file.
    yarnNix = ./yarn.nix;

    yarnFlags = defaultYarnFlags ++ ["--production=true"];

    buildPhase = ''
      source ${./nix/expectShFunctions.sh}

      expectFilePresent ./node_modules/.yarn-integrity

      # check dependencies are installed
      expectFilePresent ./node_modules/@yarnpkg/lockfile/package.json

      # check devDependencies are not installed
      expectFileOrDirAbsent ./node_modules/.bin/eslint
      expectFileOrDirAbsent ./node_modules/eslint/package.json
    '';
  };

  fixup_yarn_lock = stdenv.mkDerivation {
    name = "fixup_yarn_lock";

    buildInputs = [ nodejs ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/bin

      cp ${./lib/urlToName.js} $out/lib/urlToName.js
      cp ${./internal/fixup_yarn_lock.js} $out/bin/fixup_yarn_lock

      patchShebangs $out
    '';
  };
}
