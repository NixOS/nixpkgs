{ lib, stdenv, buildGoModule, fetchFromGitHub, removeReferencesTo
, tzdata, wire
, yarn, nodejs, python3, cacert
, jq, moreutils
, nix-update-script, nixosTests, xcbuild
}:

let
  # We need dev dependencies to run webpack, but patch away
  # `cypress` (and @grafana/e2e which has a direct dependency on cypress).
  # This attempts to download random blobs from the Internet in
  # postInstall. Also, it's just a testing framework, so not worth the hassle.
  patchAwayGrafanaE2E = ''
    find . -name package.json | while IFS=$'\n' read -r pkg_json; do
      <"$pkg_json" jq '. + {
        "devDependencies": .devDependencies | del(."@grafana/e2e") | del(.cypress)
      }' | sponge "$pkg_json"
    done
    rm -r packages/grafana-e2e
  '';
in
buildGoModule rec {
  pname = "grafana";
  version = "10.4.8";

  subPackages = [ "pkg/cmd/grafana" "pkg/cmd/grafana-server" "pkg/cmd/grafana-cli" ];

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana";
    rev = "v${version}";
    hash = "sha256-mvPSQp/y0jyNgJ41A4AyY5pOsy+VLs1dcgcgfwlJg6U=";
  };

  # borrowed from: https://github.com/NixOS/nixpkgs/blob/d70d9425f49f9aba3c49e2c389fe6d42bac8c5b0/pkgs/development/tools/analysis/snyk/default.nix#L20-L22
  env = lib.optionalAttrs (stdenv.isDarwin && stdenv.isx86_64) {
    # Fix error: no member named 'aligned_alloc' in the global namespace.
    # Occurs while building @esfx/equatable@npm:1.0.2 on x86_64-darwin
    NIX_CFLAGS_COMPILE = "-D_LIBCPP_HAS_NO_LIBRARY_ALIGNED_ALLOCATION=1";
  };

  offlineCache = stdenv.mkDerivation {
    name = "${pname}-${version}-yarn-offline-cache";
    inherit src env;
    nativeBuildInputs = [
      yarn nodejs cacert
      jq moreutils python3
    # @esfx/equatable@npm:1.0.2 fails to build on darwin as it requires `xcbuild`
    ] ++ lib.optionals stdenv.isDarwin [ xcbuild.xcbuild ];
    postPatch = ''
      ${patchAwayGrafanaE2E}
    '';
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
    outputHash = rec {
      x86_64-linux = "sha256-BKvYnXgk7JNkjnka7Co/AfI3d+j/OapXLjS47yoSVPI=";
      aarch64-linux = x86_64-linux;
      aarch64-darwin = "sha256-Rr3NSHrb8aYt1gEfv2huexA2O/6zVIzdM56pTWSob6s=";
      x86_64-darwin = aarch64-darwin;
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  disallowedRequisites = [ offlineCache ];

  vendorHash = "sha256-gP/lW6CXQpBv9dPRTOV5+vmaqTcq+91X2jls9gDrnm0=";

  proxyVendor = true;

  nativeBuildInputs = [ wire yarn jq moreutils removeReferencesTo python3 ] ++ lib.optionals stdenv.isDarwin [ xcbuild.xcbuild ];

  postPatch = ''
    ${patchAwayGrafanaE2E}
  '';

  postConfigure = ''
    # Generate DI code that's required to compile the package.
    # From https://github.com/grafana/grafana/blob/v8.2.3/Makefile#L33-L35
    wire gen -tags oss ./pkg/server
    wire gen -tags oss ./pkg/cmd/grafana-cli/runner

    GOARCH= CGO_ENABLED=0 go generate ./pkg/plugins/plugindef
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
    yarn --immutable-cache

    # The build OOMs on memory constrained aarch64 without this
    export NODE_OPTIONS=--max_old_space_size=4096
  '';

  postBuild = ''
    # After having built all the Go code, run the JS builders now.
    yarn run build
    yarn run plugins:build-bundled
  '';

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
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
    maintainers = with maintainers; [ offline fpletz willibutz globin ma27 Frostman ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    mainProgram = "grafana-server";
  };
}
