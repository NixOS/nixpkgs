{ lib, stdenv, fetchFromGitHub, buildGoModule, makeWrapper, runCommand
, moreutils, jq, git, zip, rsync, pkgconfig, yarn, python2
, nodejs-12_x, libsecret, xorg, ripgrep, darwin ? null }:

assert stdenv.isDarwin -> darwin != null;

let
  system = stdenv.hostPlatform.system;

  nodejs = nodejs-12_x;
  python = python2;
  yarn' = yarn.override { inherit nodejs; };
  defaultYarnOpts = [ "frozen-lockfile" "non-interactive" "no-progress"];

in stdenv.mkDerivation rec {
  pname = "code-server";
  version = "3.8.0";
  commit = "c4610f7829701aadb045d450013b84491c30580d";

  src = fetchFromGitHub {
    owner = "cdr";
    repo = "code-server";
    rev = "v${version}";
    sha256 = "1snc7dbqfz53337h6av2zhkrn54ypanxljs5by4jqczq96c2v6yk";
  };

  cloudAgent = buildGoModule rec {
    pname = "cloud-agent";
    version = "0.2.1";
    commit = "5beac91dd5feab9c745d58fda8118a0efaa1ef74";

    src = fetchFromGitHub {
      owner = "cdr";
      repo = "cloud-agent";
      rev = "v${version}";
      sha256 = "06fpiwxjz2cgzw4ks9sk3376rprkd02khfnb10hg7dhn3y9gp7x8";
    };

    vendorSha256 = "0k9v10wkzx53r5syf6bmm81gr4s5dalyaa07y9zvx6vv5r2h0661";

    prePatch = ''
      # the cloud-agent release tag has an empty version string, so add it back in
      substituteInPlace internal/version/version.go \
        --replace 'var Version string' 'var Version string = "v${version}"'
    '';
  };

  yarnCache = stdenv.mkDerivation {
    name = "${pname}-${version}-${system}-yarn-cache";
    inherit src;
    phases = ["unpackPhase" "buildPhase"];
    nativeBuildInputs = [ yarn' git ];
    buildPhase = ''
      export HOME=$PWD

      yarn config set yarn-offline-mirror $out
      find "$PWD" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} yarn --cwd {} \
          --frozen-lockfile --ignore-scripts --ignore-platform \
          --ignore-engines --no-progress --non-interactive
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";

    # to get hash values use nix-build -A code-server.prefetchYarnCache
    outputHash = {
      x86_64-linux = "0xc1yjz53ydg1mwyc2rp4hq20hg6i4aiirfwsnykjw1zm79qgrgb";
      x86_64-darwin = "0xc1yjz53ydg1mwyc2rp4hq20hg6i4aiirfwsnykjw1zm79qgrgb";
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
  buildInputs = stdenv.lib.optionals (!stdenv.isDarwin) [ libsecret ]
    ++ [ xorg.libX11 xorg.libxkbfile ]
    ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      AppKit Cocoa Security
    ] ++ [
      # Used for vscode-sqlite3 package
      darwin.cctools
    ])
  ;

  postPatch = ''
    export HOME=$PWD

    patchShebangs ./ci

    # remove unnecessary git config command
    substituteInPlace lib/vscode/build/npm/postinstall.js \
      --replace "cp.execSync('git config pull.rebase true');" ""

    # allow offline install for postinstall scripts in extensions
    grep -rl "yarn install" --include package.json lib/vscode/extensions \
      | xargs sed -i 's/yarn install/yarn install --offline/g'

    substituteInPlace ci/dev/postinstall.sh \
      --replace 'yarn' 'yarn --ignore-scripts'

    # remove download of coder-cloud agent
    sed -i ':a;N;$!ba;s/\n  OS=.*work"\n  fi\n//' ci/build/npm-postinstall.sh

    # use offline cache when installing release packages
    substituteInPlace ci/build/npm-postinstall.sh \
      --replace 'yarn --production' 'yarn --production --offline'

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
    # run yarn offline by default
    echo '--install.offline true' >> .yarnrc

    # set default yarn opts
    ${lib.concatMapStrings (option: ''
      yarn --offline config set ${option}
    '') defaultYarnOpts}

    # set offline mirror to yarn cache we created in previous steps
    yarn --offline config set yarn-offline-mirror "${yarnCache}"

    # link coder-cloud agent from nix store
    ln -s "${cloudAgent}/bin/cloud-agent" ./lib/coder-cloud-agent

    # skip unnecessary electron download
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1

  '' + stdenv.lib.strings.optionalString stdenv.isLinux ''
    
    # set nodedir, so we can build binaries later
    npm config set nodedir "${nodeSources}"

    # skip browser downloads for playwright. Browser downloads are patched
    # out entirely on Darwin
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
    # will not be able to find /usr/bin/env, as it does not exist in sandbox
    patchShebangs .

    '' + stdenv.lib.strings.optionalString stdenv.isDarwin ''

    # Playwright is only needed for tests, we can disable it for builds.
    # There's an environment variable to disable downloads, but the package makes a breaking call to
    # sw_vers before that variable is checked.
    patch -p1 -i ${./darwin-playwright.patch}

    # fsevents build fails on Darwin. It's an optional package, but the subsequent rebuild
    # treats it as mandatory
    patch -p1 -i ${./darwin-fsevents.patch}

    '' + ''

    # rebuild binaries, we use npm here, as yarn does not provide an alternative
    # that would not attempt to try to reinstall everything and break our
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

    # link coder-cloud agent from nix store
    ln -s "${cloudAgent}/bin/cloud-agent" $out/libexec/code-server/lib/coder-cloud-agent

    # create wrapper
    makeWrapper "${nodejs-12_x}/bin/node" "$out/bin/code-server" \
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
    platforms = ["x86_64-linux" "x86_64-darwin"];
  };
}
