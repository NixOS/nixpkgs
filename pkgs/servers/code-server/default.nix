{ lib, stdenv, fetchFromGitHub, buildGoModule, makeWrapper, runCommand
, cacert, moreutils, jq, git, rsync, pkg-config, yarn, python3
, esbuild, nodejs-14_x, node-gyp, libsecret, xorg, ripgrep
, AppKit, Cocoa, CoreServices, Security, cctools, xcbuild }:

let
  system = stdenv.hostPlatform.system;

  nodejs = nodejs-14_x;
  python = python3;
  yarn' = yarn.override { inherit nodejs; };
  defaultYarnOpts = [ "frozen-lockfile" "non-interactive" "no-progress"];

  # replaces esbuild's download script with a binary from nixpkgs
  patchEsbuild = path : version : ''
    mkdir -p ${path}/node_modules/esbuild/bin
    jq "del(.scripts.postinstall)" ${path}/node_modules/esbuild/package.json | sponge ${path}/node_modules/esbuild/package.json
    sed -i 's/${version}/${esbuild.version}/g' ${path}/node_modules/esbuild/lib/main.js
    ln -s -f ${esbuild}/bin/esbuild ${path}/node_modules/esbuild/bin/esbuild
  '';

in stdenv.mkDerivation rec {
  pname = "code-server";
  version = "4.0.1";
  commit = "7fe23daf009e5234eaa54a1ea5ff26df384c47ac";

  src = fetchFromGitHub {
    owner = "cdr";
    repo = "code-server";
    rev = "v${version}";
    sha256 = "1s3dcmzlkyh7qfs3ai1p7dlp45iys0ax1fbxxz17p395pw9anrrl";
  };

  cloudAgent = buildGoModule rec {
    pname = "cloud-agent";
    version = "0.2.3";

    src = fetchFromGitHub {
      owner = "cdr";
      repo = "cloud-agent";
      rev = "v${version}";
      sha256 = "14i1qq273f0yn5v52ryiqwj7izkd1yd212di4gh4bqypmmzhw3jj";
    };

    vendorSha256 = "0k9v10wkzx53r5syf6bmm81gr4s5dalyaa07y9zvx6vv5r2h0661";

    postPatch = ''
      # the cloud-agent release tag has an empty version string, so add it back in
      substituteInPlace internal/version/version.go \
        --replace 'var Version string' 'var Version string = "v${version}"'
    '';
  };

  yarnCache = stdenv.mkDerivation {
    name = "${pname}-${version}-${system}-yarn-cache";
    inherit src;
    nativeBuildInputs = [ yarn' git cacert ];
    buildPhase = ''
      export HOME=$PWD
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"

      yarn --cwd "./vendor" install --modules-folder modules --ignore-scripts --frozen-lockfile

      yarn config set yarn-offline-mirror $out
      find "$PWD" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} yarn --cwd {} \
          --frozen-lockfile --ignore-scripts --ignore-platform \
          --ignore-engines --no-progress --non-interactive
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";

    # to get hash values use nix-build -A code-server.prefetchYarnCache
    outputHash = "0qmfsirld1qfl2s26rxbpmvxsyj2pvzkgk8w89zlrgbhgc5fj8p9";
  };

  nativeBuildInputs = [
    nodejs yarn' python pkg-config makeWrapper git rsync jq moreutils
  ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ libsecret ]
    ++ (with xorg; [ libX11 libxkbfile ])
    ++ lib.optionals stdenv.isDarwin [
      AppKit Cocoa CoreServices Security cctools xcbuild
    ];

  patches = [
    # remove download of coder-cloud agent
    ./remove-cloud-agent-download.patch
  ];

  postPatch = ''
    export HOME=$PWD

    patchShebangs ./ci

    # inject git commit
    substituteInPlace ci/build/build-release.sh \
      --replace '$(git rev-parse HEAD)' "$commit"
  '';

  configurePhase = ''
    # run yarn offline by default
    echo '--install.offline true' >> .yarnrc

    # set default yarn opts
    ${lib.concatMapStrings (option: ''
      yarn --offline config set ${option}
    '') defaultYarnOpts}

    # set offline mirror to yarn cache we created in previous steps
    yarn --offline config set yarn-offline-mirror "${yarnCache}"

    # link coder-cloud agent from nix store
    mkdir -p lib
    ln -s "${cloudAgent}/bin/cloud-agent" ./lib/coder-cloud-agent

    # skip unnecessary electron download
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1

    # set nodedir to prevent node-gyp from downloading headers
    # taken from https://nixos.org/manual/nixpkgs/stable/#javascript-tool-specific
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}

    # use updated node-gyp. fixes the following error on Darwin:
    # PermissionError: [Errno 1] Operation not permitted: '/usr/sbin/pkgutil'
    export npm_config_node_gyp=${node-gyp}/lib/node_modules/node-gyp/bin/node-gyp.js
  '';

  buildPhase = ''
    # install code-server dependencies
    yarn --offline --ignore-scripts

    # patch shebangs of everything to allow binary packages to build
    patchShebangs .

    # Skip shellcheck download
    jq "del(.scripts.preinstall)" node_modules/shellcheck/package.json | sponge node_modules/shellcheck/package.json

    # rebuild binary packages now that scripts have been patched
    npm rebuild

    # Replicate ci/dev/postinstall.sh
    echo "----- Replicate ci/dev/postinstall.sh"
    yarn --cwd "./vendor" install --modules-folder modules --offline --ignore-scripts --frozen-lockfile

    # Replicate vendor/postinstall.sh
    echo " ----- Replicate vendor/postinstall.sh"
    yarn --cwd "./vendor/modules/code-oss-dev" --offline --frozen-lockfile --ignore-scripts install

    # remove all built-in extensions, as these are 3rd party extensions that
    # get downloaded from vscode marketplace
    jq --slurp '.[0] * .[1]' "vendor/modules/code-oss-dev/product.json" <(
      cat << EOF
    {
      "builtInExtensions": []
    }
    EOF
    ) | sponge vendor/modules/code-oss-dev/product.json

    # disable automatic updates
    sed -i '/update.mode/,/\}/{s/default:.*/default: "none",/g}' \
      vendor/modules/code-oss-dev/src/vs/platform/update/common/update.config.contribution.ts

    # put ripgrep binary into bin, so postinstall does not try to download it
    find -name vscode-ripgrep -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;

    # Playwright is only needed for tests, we can disable it for builds.
    # There's an environment variable to disable downloads, but the package makes a breaking call to
    # sw_vers before that variable is checked.
    patch -p1 -i ${./playwright.patch}

    # Patch out remote download of nodejs from build script
    patch -p1 -i ${./remove-node-download.patch}

    # Replicate install vscode dependencies without running script for all vscode packages
    # that require patching for postinstall scripts to succeed
    find ./vendor/modules/code-oss-dev -path "*node_modules" -prune -o \
      -path "./*/*/*/*/*" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} yarn --cwd {} \
          --frozen-lockfile --offline --ignore-scripts --ignore-engines


    # patch shebangs of everything to allow binary packages to build
    patchShebangs .

    ${patchEsbuild "./vendor/modules/code-oss-dev/build" "0.12.6"}
    ${patchEsbuild "./vendor/modules/code-oss-dev/extensions" "0.11.23"}
  '' + lib.optionalString stdenv.isDarwin ''
    # use prebuilt binary for @parcel/watcher, which requires macOS SDK 10.13+
    # (see issue #101229)
    pushd ./vendor/modules/code-oss-dev/remote/node_modules/@parcel/watcher
    mkdir -p ./build/Release
    mv ./prebuilds/darwin-x64/node.napi.glibc.node ./build/Release/watcher.node
    jq "del(.scripts) | .gypfile = false" ./package.json | sponge ./package.json
    popd
  '' + ''
    # rebuild binaries, we use npm here, as yarn does not provide an alternative
    # that would not attempt to try to reinstall everything and break our
    # patching attempts
    npm rebuild --prefix vendor/modules/code-oss-dev --update-binary

    # run postinstall scripts after patching
    find ./vendor/modules/code-oss-dev -path "*node_modules" -prune -o \
      -path "./*/*/*/*/*" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} sh -c 'jq -e ".scripts.postinstall" {}/package.json >/dev/null && yarn --cwd {} postinstall --frozen-lockfile --offline || true'

    # build code-server
    yarn build

    # build vscode
    yarn build:vscode

    # create release
    yarn release
  '';

  installPhase = ''
    mkdir -p $out/libexec/code-server $out/bin

    # copy release to libexec path
    cp -R -T release "$out/libexec/code-server"

    # install only production dependencies
    yarn --offline --cwd "$out/libexec/code-server" --production

    # link coder-cloud agent from nix store
    mkdir -p $out/libexec/code-server/lib
    ln -s "${cloudAgent}/bin/cloud-agent" $out/libexec/code-server/lib/coder-cloud-agent

    # create wrapper
    makeWrapper "${nodejs-14_x}/bin/node" "$out/bin/code-server" \
      --add-flags "$out/libexec/code-server/out/node/entry.js"
  '';

  passthru = {
    prefetchYarnCache = lib.overrideDerivation yarnCache (d: {
      outputHash = lib.fakeSha256;
    });
  };

  meta = with lib; {
    description = "Run VS Code on a remote server";
    longDescription = ''
      code-server is VS Code running on a remote server, accessible through the
      browser.
    '';
    homepage = "https://github.com/cdr/code-server";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
