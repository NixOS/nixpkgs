{ stdenv, lib, fetchurl, linkFarm, runCommand, nodejs, yarn }:

let
  unlessNull = item: alt:
    if item == null then alt else item;

  yarn2nix = mkYarnPackage {
    src = ./.;
    yarnNix = ./yarn.nix;

    passthru = {
      inherit
        defaultYarnFlags
        linkNodeModulesHook
        mkYarnModules
        mkYarnNix
        mkYarnPackage
        # Export yarn again to make it easier to find out which yarn was used.
        yarn
        ;
    };

    meta = with lib; {
      description = "generate nix expressions from a yarn.lock file";
      homepage = https://github.com/moretea/yarn2nix;
      license = licenses.gpl3;
      maintainers = with maintainers; [ manveru zimbatm ];
    };
  };

  # Generates the yarn.nix from the yarn.lock file
  mkYarnNix = yarnLock:
    runCommand "yarn.nix" {}
      "${yarn2nix}/bin/yarn2nix --lockfile ${yarnLock} --no-patch > $out";

  # Loads the generated offline cache. This will be used by yarn as
  # the package source.
  importOfflineCache = yarnNix:
    let
      pkg = import yarnNix { inherit fetchurl linkFarm; };
    in
      pkg.offline_cache;

  defaultYarnFlags = [
    "--offline"
    "--frozen-lockfile"
    "--ignore-engines"
    "--ignore-scripts"
  ];

  mkYarnModules = {
    name,
    packageJSON,
    yarnLock,
    yarnNix ? mkYarnNix yarnLock,
    yarnFlags ? defaultYarnFlags,
    pkgConfig ? {},
    preBuild ? "",
  }:
    let
      offlineCache = importOfflineCache yarnNix;
      extraBuildInputs = (lib.flatten (builtins.map (key:
        pkgConfig.${key} . buildInputs or []
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
    in
    stdenv.mkDerivation {
      inherit name preBuild;
      phases = ["configurePhase" "buildPhase"];
      buildInputs = [ yarn nodejs ] ++ extraBuildInputs;

      configurePhase = ''
        # Yarn writes cache directories etc to $HOME.
        export HOME=$PWD/yarn_home
      '';

      buildPhase = ''
        runHook preBuild

        cp ${packageJSON} ./package.json
        cp ${yarnLock} ./yarn.lock
        chmod +w ./yarn.lock

        yarn config --offline set yarn-offline-mirror ${offlineCache}

        # Do not look up in the registry, but in the offline cache.
        # TODO: Ask upstream to fix this mess.
        sed -i -E 's|^(\s*resolved\s*")https?://.*/|\1|' yarn.lock
        yarn install ${lib.escapeShellArgs yarnFlags}

        ${lib.concatStringsSep "\n" postInstall}

        mkdir $out
        mv node_modules $out/
        patchShebangs $out
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

  mkYarnPackage = {
    name ? null,
    src,
    packageJSON ? src + "/package.json",
    yarnLock ? src + "/yarn.lock",
    yarnNix ? mkYarnNix yarnLock,
    yarnFlags ? defaultYarnFlags,
    yarnPreBuild ? "",
    pkgConfig ? {},
    extraBuildInputs ? [],
    publishBinsFor ? null,
    ...
  }@attrs:
    let
      package = lib.importJSON packageJSON;
      pname = package.name;
      version = package.version;
      deps = mkYarnModules {
        name = "${pname}-modules-${version}";
        preBuild = yarnPreBuild;
        inherit packageJSON yarnLock yarnNix yarnFlags pkgConfig;
      };
      publishBinsFor_ = unlessNull publishBinsFor [pname];
    in stdenv.mkDerivation (builtins.removeAttrs attrs ["pkgConfig"] // {
      inherit src;

      name = unlessNull name "${pname}-${version}";

      buildInputs = [ yarn nodejs ] ++ extraBuildInputs;

      node_modules = deps + "/node_modules";

      configurePhase = attrs.configurePhase or ''
        runHook preConfigure

        if [ -d npm-packages-offline-cache ]; then
          echo "npm-pacakges-offline-cache dir present. Removing."
          rm -rf npm-packages-offline-cache
        fi

        if [[ -d node_modules || -L node_modules ]]; then
          echo "./node_modules is present. Removing."
          rm -rf node_modules
        fi

        mkdir -p node_modules
        ln -s $node_modules/* node_modules/
        ln -s $node_modules/.bin node_modules/

        if [ -d node_modules/${pname} ]; then
          echo "Error! There is already an ${pname} package in the top level node_modules dir!"
          exit 1
        fi

        runHook postConfigure
      '';

      # Replace this phase on frontend packages where only the generated
      # files are an interesting output.
      installPhase = attrs.installPhase or ''
        runHook preInstall

        mkdir -p $out
        cp -r node_modules $out/node_modules
        cp -r . $out/node_modules/${pname}
        rm -rf $out/node_modules/${pname}/node_modules

        mkdir $out/bin
        node ${./fixup_bin.js} $out ${lib.concatStringsSep " " publishBinsFor_}

        runHook postInstall
      '';

      passthru = {
        inherit package deps;
      } // (attrs.passthru or {});

      # TODO: populate meta automatically
    });
in
  yarn2nix
