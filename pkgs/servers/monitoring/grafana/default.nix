{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  removeReferencesTo,
  tzdata,
  wire,
  yarn,
  nodejs,
  python3,
  cacert,
  jq,
  moreutils,
  nix-update-script,
  nixosTests,
  xcbuild,
  faketty,
  git,
}:

let
  # Grafana seems to just set it to the latest version available
  # nowadays.
  # NOTE: sometimes, this is a no-op (i.e. `--replace-fail "X" "X"`).
  # This is because Grafana raises the Go version above the patch-level we have
  # on master if a security fix landed in Go (and our go may go through staging first).
  #
  # I(Ma27) decided to leave the code a no-op if this is not the case because
  # pulling it out of the Git history every few months and checking which files
  # we need to update now is slightly annoying.
  patchGoVersion = ''
    find . -name go.mod -not -path "./.bingo/*" -print0 | while IFS= read -r -d ''' line; do
      substituteInPlace "$line" \
        --replace-fail "go 1.23.7" "go 1.23.7"
    done
    find . -name go.work -print0 | while IFS= read -r -d ''' line; do
      substituteInPlace "$line" \
        --replace-fail "go 1.23.7" "go 1.23.7"
    done
    substituteInPlace Makefile \
      --replace-fail "GO_VERSION = 1.23.7" "GO_VERSION = 1.23.7"
  '';
in
buildGoModule rec {
  pname = "grafana";
  version = "11.6.0";

  subPackages = [
    "pkg/cmd/grafana"
    "pkg/cmd/grafana-server"
    "pkg/cmd/grafana-cli"
  ];

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana";
    rev = "v${version}";
    hash = "sha256-oXotHi79XBhxD/qYC7QDQwn7jiX0wKWe/RXZS5DwN9o=";
  };

  # borrowed from: https://github.com/NixOS/nixpkgs/blob/d70d9425f49f9aba3c49e2c389fe6d42bac8c5b0/pkgs/development/tools/analysis/snyk/default.nix#L20-L22
  env = {
    CYPRESS_INSTALL_BINARY = 0;
  };

  offlineCache = stdenv.mkDerivation {
    name = "${pname}-${version}-yarn-offline-cache";
    inherit src env;
    nativeBuildInputs = [
      yarn
      nodejs
      cacert
      jq
      moreutils
      # required to run old node-gyp
      (python3.withPackages (ps: [ ps.distutils ]))
      git
      # @esfx/equatable@npm:1.0.2 fails to build on darwin as it requires `xcbuild`
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild.xcbuild ];
    buildPhase = ''
      runHook preBuild
      export HOME="$(mktemp -d)"
      yarn config set enableTelemetry 0
      yarn config set cacheFolder $out
      yarn config set --json supportedArchitectures.os '[ "linux", "darwin" ]'
      yarn config set --json supportedArchitectures.cpu '["arm", "arm64", "ia32", "x64"]'
      yarn
      runHook postBuild
    '';
    dontConfigure = true;
    dontInstall = true;
    dontFixup = true;
    outputHashMode = "recursive";
    outputHash =
      rec {
        x86_64-linux = "sha256-52Sq7YJHhs0UICMOtEDta+bY7b/1SdNfzUOigQhH3E4=";
        aarch64-linux = x86_64-linux;
        aarch64-darwin = "sha256-9AJbuA1WDGiln2ea0nqD9lDMhKWdYyVkgFyFLB6/Etc=";
        x86_64-darwin = aarch64-darwin;
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  disallowedRequisites = [ offlineCache ];

  postPatch = patchGoVersion;

  vendorHash = "sha256-cYE43OAagPHFhWsUJLMcJVfsJj6d0vUqzjbAviYSuSc=";

  proxyVendor = true;

  nativeBuildInputs = [
    wire
    yarn
    jq
    moreutils
    removeReferencesTo
    # required to run old node-gyp
    (python3.withPackages (ps: [ ps.distutils ]))
    faketty
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild.xcbuild ];

  postConfigure = ''
    # Generate DI code that's required to compile the package.
    # From https://github.com/grafana/grafana/blob/v8.2.3/Makefile#L33-L35
    wire gen -tags oss ./pkg/server
    wire gen -tags oss ./pkg/cmd/grafana-cli/runner

    GOARCH= CGO_ENABLED=0 go generate ./kinds/gen.go
    GOARCH= CGO_ENABLED=0 go generate ./public/app/plugins/gen.go
    # Setup node_modules
    export HOME="$(mktemp -d)"

    # Help node-gyp find Node.js headers
    # (see https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md#pitfalls-javascript-yarn2nix-pitfalls)
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}

    yarn config set enableTelemetry 0
    yarn config set cacheFolder $offlineCache
    yarn install --immutable-cache

    # The build OOMs on memory constrained aarch64 without this
    export NODE_OPTIONS=--max_old_space_size=4096
  '';

  postBuild = ''
    # After having built all the Go code, run the JS builders now.

    # Workaround for https://github.com/nrwl/nx/issues/22445
    faketty yarn run build
    yarn run plugins:build-bundled
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  # On Darwin, files under /usr/share/zoneinfo exist, but fail to open in sandbox:
  # TestValueAsTimezone: date_formats_test.go:33: Invalid has err for input "Europe/Amsterdam": operation not permitted
  preCheck = ''
    export ZONEINFO=${tzdata}/share/zoneinfo
  '';

  postInstall = ''
    mkdir -p $out/share/grafana
    cp -r public conf $out/share/grafana/
  '';

  postFixup = ''
    while read line; do
      remove-references-to -t $offlineCache "$line"
    done < <(find $out -type f -name '*.js.map' -or -name '*.js')
  '';

  passthru = {
    tests = { inherit (nixosTests) grafana; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.agpl3Only;
    homepage = "https://grafana.com";
    maintainers = with maintainers; [
      offline
      fpletz
      willibutz
      globin
      ma27
      Frostman
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "grafana-server";
  };
}
