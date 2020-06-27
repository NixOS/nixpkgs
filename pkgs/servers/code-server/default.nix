{ stdenv, fetchFromGitHub, makeWrapper, runCommand
, moreutils, jq, git, zip, rsync, pkgconfig, yarn, python2
, nodejs-12_x, libsecret, xorg, ripgrep, nettools }:

let
  system = stdenv.hostPlatform.system;

  nodejs = nodejs-12_x;
  python = python2;
  yarn' = yarn.override { inherit nodejs; };
  defaultYarnOpts = [ "frozen-lockfile" "non-interactive" "no-progress"];

in stdenv.mkDerivation rec {
  pname = "code-server";
  version = "3.4.1";
  commit = "d3773c11f147bdd7a4f5acfefdee23c26f069e76";

  src = fetchFromGitHub {
    owner = "cdr";
    repo = "code-server";
    rev = version;
    sha256 = "PfDD0waloppGZ09zCQ9ggBeVL/Dhfv6QmEs/fs7QLtA=";
    fetchSubmodules = true;
  };

  yarnCache = stdenv.mkDerivation {
    name = "${pname}-${version}-${system}-yarn-cache";
    inherit src;
    phases = ["unpackPhase" "buildPhase"];
    nativeBuildInputs = [ yarn' git ];
    buildPhase = ''
      export HOME=$PWD

      patchShebangs ./ci

      # apply code-server patches as code-server has patched vscode yarn.lock
      yarn vscode:patch

      yarn config set yarn-offline-mirror $out
      find "$PWD" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} yarn --cwd {} \
          --frozen-lockfile --ignore-scripts --ignore-platform \
          --ignore-engines --no-progress --non-interactive
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";

    # to get hash values use nix-build -A code-server.yarnPrefetchCache
    outputHash = {
      x86_64-linux = "Zze2hEm2Np+SyQ0KXy5CZr5wilZbHBYXNYcRJBUUkQo=";
      aarch64-linux = "LiIvGuBismWSL2yV2DuKUWDjIzuIQU/VVxtiD4xJ+6Q=";
    }.${system} or (throw "Unsupported system ${system}");
  };

  # Extract the Node.js source code which is used to compile packages with
  # native bindings
  nodeSources = runCommand "node-sources" {} ''
    tar --no-same-owner --no-same-permissions -xf ${nodejs.src}
    mv node-* $out
  '';

  nativeBuildInputs = [
    nodejs yarn' python pkgconfig zip makeWrapper git rsync jq moreutils
  ];
  buildInputs = [ libsecret xorg.libX11 xorg.libxkbfile ];

  patchPhase = ''
    export HOME=$PWD

    patchShebangs ./ci

    # apply code-server vscode patches
    yarn vscode:patch

    # allow offline install for vscode
    substituteInPlace lib/vscode/build/npm/postinstall.js \
      --replace '--ignore-optional' '--offline'

    # fix path to ifconfig, so vscode can get mac address
    substituteInPlace lib/vscode/src/vs/base/node/macAddress.ts \
      --replace '/sbin/ifconfig' '${nettools}/bin/ifconfig'

    # disable automatic updates
    sed -i '/update.mode/,/\}/{s/default:.*/default: "none",/g}' \
      lib/vscode/src/vs/platform/update/common/update.config.contribution.ts

    # inject git commit
    substituteInPlace ci/build/build-release.sh \
      --replace '$(git rev-parse HEAD)' "$commit"

    # remove all built-in extensions, as these are 3rd party extensions that
    # gets downloaded from vscode marketplace
    jq --slurp '.[0] * .[1]' "lib/vscode/product.json" <(
      cat << EOF
    {
      "builtInExtensions": []
    }
    EOF
    ) | sponge lib/vscode/product.json
  '';

  configurePhase = ''
    # set default yarn opts
    ${stdenv.lib.concatMapStrings (option: ''
      yarn --offline config set ${option}
    '') defaultYarnOpts}

    # set offline mirror to yarn cache we created in previous steps
    yarn --offline config set yarn-offline-mirror "${yarnCache}"

    # set nodedir, so we can build binaries later
    npm config set nodedir "${nodeSources}"

    # skip browser downloads for playwright
    export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD="true"
  '';

  buildPhase = ''
    # install code-server dependencies
    yarn --offline

    # install vscode dependencies without running script for all vscode packages
    # that require patching for postinstall scripts to succeed
    for d in lib/vscode lib/vscode/build; do
      yarn --offline --cwd $d --offline --ignore-scripts
    done

    # put ripgrep binary into bin, so postinstall does not try to download it
    find -name vscode-ripgrep -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;

    # patch shebangs of everything, also cached files, as otherwise postinstall
    # will not be able to find /usr/bin/env, as it does not exists in sandbox
    patchShebangs .

    # rebuild binaries, we use npm here, as yarn does not provider alternative
    # that would not atempt to try to reinstall everything and break out
    # patching attempts
    npm rebuild --prefix lib/vscode --update-binary

    # run postinstall scripts, which eventually do yarn install on all
    # additional requirements
    yarn --cwd lib/vscode postinstall --frozen-lockfile --offline

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

    # create wrapper
    makeWrapper "${nodejs-12_x}/bin/node" "$out/bin/code-server" \
      --add-flags "$out/libexec/code-server/out/node/entry.js"
  '';

  passthru = {
    prefetchYarnCache = stdenv.lib.overrideDerivation yarnCache (d: {
      outputHash = stdenv.lib.fakeSha256;
    });
  };

  meta = with stdenv.lib; {
    description = "Run VS Code on a remote server.";
    longDescription = ''
      code-server is VS Code running on a remote server, accessible through the
      browser.
    '';
    homepage = "https://github.com/cdr/code-server";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms = ["x86_64-linux"];
  };
}
