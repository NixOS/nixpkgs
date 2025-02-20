{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  cacert,
  moreutils,
  jq,
  git,
  pkg-config,
  runCommand,
  nodejs,
  node-gyp,
  libsecret,
  libkrb5,
  xorg,
  ripgrep,
  cctools,
  nixosTests,
}:
let

  version = "1.96.4";
  hash = "sha256-TUM2R3TT4xZ1BTsZaBRbq2E8/uPazKryEoyBenMJwzE=";
  nodeModulesHash = "sha256-Zdk8obKjQnLkPyQ17F44YQ1LkK4YHgbhXeom5Vf5M8g=";

  system = stdenv.hostPlatform.system;

  vsBuildTarget =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "darwin-x64";
      aarch64-darwin = "darwin-arm64";
    }
    .${system} or (throw "Unsupported system ${system}");

in
stdenv.mkDerivation (finalAttrs: {
  pname = "openvscode-server";

  inherit nodejs version;

  src = fetchFromGitHub {
    owner = "gitpod-io";
    repo = "openvscode-server";
    rev = "openvscode-server-v${version}";
    inherit hash;
  };

  ## fetchNpmDeps doesn't correctly process git dependencies
  ## presumably because of https://github.com/npm/cli/issues/5170
  ## therefore, we're fetching all the node_module folders into
  ## a single FOD, and unpack it in configurePhase
  nodeModules =
    runCommand "openvscode-server-node-modules"
      {
        inherit (finalAttrs) src nativeBuildInputs;
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = nodeModulesHash;
      }
      ''
        runPhase unpackPhase
        export HOME=$TMPDIR/home
        npm config set progress false
        npm config set cafile ${cacert}/etc/ssl/certs/ca-bundle.crt
        for p in $(find -name package.json -exec dirname {} \;)
        do (
          set -x
          cd $p
          if [ -e node_modules ]
          then
            echo >&2 "File exists $p/node_modules"
            exit 0
          fi
          mkdir node_modules
          if [ -e package-lock.json ]
          then npm ci --ignore-scripts --log-level=verbose
          else npm i --ignore-scripts --log-level=verbose
          fi
          mkdir -p $out/$p
          cp -r node_modules $out/$p/
        )
        done
      '';

  npm_config_nodedir = nodejs;
  npm_config_node_gyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";

  NODE_OPTIONS = "--openssl-legacy-provider";
  NODE_ENV = "production";
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  NIX_NODEJS_BUILDNPMPACKAGE = "1";
  makeCacheWritable = true;

  nativeBuildInputs = [
    nodejs
    nodejs.python
    pkg-config
    makeWrapper
    git
    jq
    moreutils
  ];

  buildInputs =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [ libsecret ]
    ++ (with xorg; [
      libX11
      libxkbfile
      libkrb5
    ])
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
    ];

  # remove all built-in extensions, as these are 3rd party extensions that
  # get downloaded from vscode marketplace
  postPatch =
    ''
      jq --slurp '.[0] * .[1]' "product.json" <(
        cat << EOF
      {
        "builtInExtensions": []
      }
      EOF
      ) | sponge product.json
      echo "Updated product.json"
    ''
    ## build/lib/node.ts picks up nodejs version from remote/.npmrc
    ## and prefetches it into .build/node/v{version}/{target}/node
    ## so we pre-seed it here
    + ''
      sed -i 's/target=.*/target="${nodejs.version}"/' remote/.npmrc
      mkdir -p .build/node/v${nodejs.version}/${vsBuildTarget}
      ln -s ${nodejs}/bin/node .build/node/v${nodejs.version}/${vsBuildTarget}/node
    '';

  configurePhase =
    ''
      export HOME=$TMPDIR/home
      mkdir -p $HOME
    ''
    ## unpack all of the prefetched node_modules folders
    + ''
      for p in $(find -name package.json -exec dirname {} \;)
      do (
        cd $p
        if [ -e node_modules ]
        then
          echo >&2 "File exists $p/node_modules"
          exit 0
        fi
        cp -r $nodeModules/$p/node_modules .
        chmod -R 700 node_modules
      )
      patchShebangs $p/node_modules
      done
    ''
    ## put ripgrep binary into bin so postinstall does not try to download it
    + ''
      find -path "*@vscode/ripgrep" -type d \
        -execdir mkdir -p {}/bin \; \
        -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;
    ''
    ## pre-seed node-gyp
    + ''
      mkdir -p $HOME/.node-gyp/${nodejs.version}
      echo 11 > $HOME/.node-gyp/${nodejs.version}/installVersion
      ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    ''
    ## rebuild native binaries
    + ''
      echo >&2 "Rebuilding from source in ./remote"
      npm --prefix ./remote rebuild --build-from-source
    ''
    ## run postinstall scripts
    + ''
      find -name package.json -type f -exec sh -c '
        if jq -e ".scripts.postinstall" {} >-
        then
          echo >&2 "Running postinstall script in $(dirname {})"
          npm --offline --prefix=$(dirname {}) run postinstall
        fi
        exit 0
      ' \;
    '';

  buildPhase = ''
    npm run gulp vscode-reh-web-${vsBuildTarget}-min
  '';

  installPhase = ''
    mkdir -p $out
    cp -R -T ../vscode-reh-web-${vsBuildTarget} $out
    ln -sf ${nodejs}/bin/node $out
  '';

  passthru.tests = {
    inherit (nixosTests) openvscode-server;
  };

  meta = {
    description = "Run VS Code on a remote machine";
    longDescription = ''
      Run upstream VS Code on a remote machine with access through a modern web
      browser from any device, anywhere.
    '';
    homepage = "https://github.com/gitpod-io/openvscode-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dguenther
      ghuntley
      emilytrau
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    # Depends on nodejs_18 that has been removed.
    broken = true;
    mainProgram = "openvscode-server";
  };
})
