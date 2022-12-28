{ lib, stdenv, fetchFromGitHub, makeWrapper, runCommand
, cacert, moreutils, jq, git, pkg-config, yarn, python3
, esbuild, nodejs-16_x-openssl_1_1, libsecret, xorg, ripgrep
, AppKit, Cocoa, Security, cctools }:

let
  system = stdenv.hostPlatform.system;

  nodejs = nodejs-16_x-openssl_1_1;
  yarn' = yarn.override { inherit nodejs; };
  defaultYarnOpts = [ "frozen-lockfile" "non-interactive" "no-progress"];

  vsBuildTarget = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  }.${system} or (throw "Unsupported system ${system}");

  # replaces esbuild's download script with a binary from nixpkgs
  patchEsbuild = path : version : ''
    mkdir -p ${path}/node_modules/esbuild/bin
    jq "del(.scripts.postinstall)" ${path}/node_modules/esbuild/package.json | sponge ${path}/node_modules/esbuild/package.json
    sed -i 's/${version}/${esbuild.version}/g' ${path}/node_modules/esbuild/lib/main.js
    ln -s -f ${esbuild}/bin/esbuild ${path}/node_modules/esbuild/bin/esbuild
  '';

in stdenv.mkDerivation rec {
  pname = "openvscode-server";
  version = "1.73.1";

  src = fetchFromGitHub {
    owner = "gitpod-io";
    repo = "openvscode-server";
    rev = "openvscode-server-v${version}";
    sha256 = "DZWAzNRRRZ/eElwRGvSK7TxstKK6X1Tj+uAxD4SOScQ=";
  };

  yarnCache = stdenv.mkDerivation {
    name = "${pname}-${version}-${system}-yarn-cache";
    inherit src;
    nativeBuildInputs = [ cacert yarn git ];
    buildPhase = ''
      export HOME=$PWD

      yarn config set yarn-offline-mirror $out
      find "$PWD" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} yarn --cwd {} \
          --frozen-lockfile --ignore-scripts --ignore-platform \
          --ignore-engines --no-progress --non-interactive
    '';

    installPhase = ''
      echo yarnCache
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-7UBXigQj7c+fuHPIM5BbRe02DuL+cs6VbQ/D84Yk8i4=";
  };

  nativeBuildInputs = [
    nodejs yarn' python3 pkg-config makeWrapper git jq moreutils
  ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ libsecret ]
    ++ (with xorg; [ libX11 libxkbfile ])
    ++ lib.optionals stdenv.isDarwin [
      AppKit Cocoa Security cctools
    ];

  patches = [
    # Patch out remote download of nodejs from build script
    ./remove-node-download.patch
  ];

  postPatch = ''
    export HOME=$PWD

    # remove all built-in extensions, as these are 3rd party extensions that
    # get downloaded from vscode marketplace
    jq --slurp '.[0] * .[1]' "product.json" <(
      cat << EOF
    {
      "builtInExtensions": []
    }
    EOF
    ) | sponge product.json
  '';

  configurePhase = ''
    # set default yarn opts
    ${lib.concatMapStrings (option: ''
      yarn --offline config set ${option}
    '') defaultYarnOpts}

    # set offline mirror to yarn cache we created in previous steps
    yarn --offline config set yarn-offline-mirror "${yarnCache}"

    # set nodedir, so we can build binaries later
    npm config set nodedir "${nodejs}"
  '';

  buildPhase = ''
    # install dependencies
    yarn --offline --ignore-scripts

    # run yarn install everywhere, skipping postinstall so we can patch esbuild
    find . -path "*node_modules" -prune -o \
      -path "./*/*" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} yarn --cwd {} \
          --frozen-lockfile --offline --ignore-scripts --ignore-engines

    ${patchEsbuild "./build" "0.12.6"}
    ${patchEsbuild "./extensions" "0.11.23"}

    # patch shebangs of node_modules to allow binary packages to build
    patchShebangs ./remote/node_modules

    # put ripgrep binary into bin so postinstall does not try to download it
    find -path "*@vscode/ripgrep" -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;
  '' + lib.optionalString stdenv.isDarwin ''
    # use prebuilt binary for @parcel/watcher, which requires macOS SDK 10.13+
    # (see issue #101229)
    pushd ./remote/node_modules/@parcel/watcher
    mkdir -p ./build/Release
    mv ./prebuilds/darwin-x64/node.napi.glibc.node ./build/Release/watcher.node
    jq "del(.scripts) | .gypfile = false" ./package.json | sponge ./package.json
    popd
  '' + ''
    # rebuild binaries, we use npm here, as yarn does not provide an alternative
    # that would not attempt to try to reinstall everything and break our
    # patching attempts
    npm --prefix ./remote rebuild --build-from-source

    # run postinstall scripts after patching
    find . -path "*node_modules" -prune -o \
      -path "./*/*" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} sh -c 'jq -e ".scripts.postinstall" {}/package.json >/dev/null && yarn --cwd {} postinstall --frozen-lockfile --offline || true'

    # build and minify
    yarn --offline gulp vscode-reh-web-${vsBuildTarget}-min
  '';

  installPhase = ''
    mkdir -p $out
    cp -R -T ../vscode-reh-web-${vsBuildTarget} $out
    ln -s ${nodejs}/bin/node $out
  '';

  meta = with lib; {
    description = "Run VS Code on a remote machine";
    longDescription = ''
      Run upstream VS Code on a remote machine with access through a modern web
      browser from any device, anywhere.
    '';
    homepage = "https://github.com/gitpod-io/openvscode-server";
    license = licenses.mit;
    maintainers = with maintainers; [ dguenther ghuntley emilytrau ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
