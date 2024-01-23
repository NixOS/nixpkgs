{ lib, stdenv, buildGoModule, fetchFromGitHub, removeReferencesTo
, tzdata, wire
, yarn, nodejs, cacert
, jq, moreutils
, nix-update-script, nixosTests
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

  # Injects a `t.Skip()` into a given test since
  # there's apparently no other way to skip tests here.
  skipTest = lineOffset: testCase: file:
    let
      jumpAndAppend = lib.concatStringsSep ";" (lib.replicate (lineOffset - 1) "n" ++ [ "a" ]);
    in ''
      sed -i -e '/${testCase}/{
      ${jumpAndAppend} t.Skip();
      }' ${file}
    '';
in
buildGoModule rec {
  pname = "grafana";
  version = "10.3.1";

  excludedPackages = [ "alert_webhook_listener" "clean-swagger" "release_publisher" "slow_proxy" "slow_proxy_mac" "macaron" "devenv" "modowners" ];

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana";
    rev = "v${version}";
    hash = "sha256-UPIq7BWTlT0omt/SM5+vkfOHvsdcx/ikkjcW9X8pcw0=";
  };

  offlineCache = stdenv.mkDerivation {
    name = "${pname}-${version}-yarn-offline-cache";
    inherit src;
    nativeBuildInputs = [
      yarn nodejs cacert
      jq moreutils
    ];
    postPatch = ''
      ${patchAwayGrafanaE2E}
    '';
    buildPhase = ''
      runHook preBuild
      export HOME="$(mktemp -d)"
      yarn config set enableTelemetry 0
      yarn config set cacheFolder $out
      yarn config set --json supportedArchitectures.os '[ "linux" ]'
      yarn config set --json supportedArchitectures.cpu '["arm", "arm64", "ia32", "x64"]'
      yarn
      runHook postBuild
    '';
    dontConfigure = true;
    dontInstall = true;
    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-70eMa8E483f/Bz7iy+4Seap1EfIdjD5krnt6W9CUows=";
  };

  disallowedRequisites = [ offlineCache ];

  vendorHash = "sha256-Gf2A22d7/8xU/ld7kveqGonVKGFCArGNansPRGhfyXM=";

  nativeBuildInputs = [ wire yarn jq moreutils removeReferencesTo ];

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
    GOARCH= CGO_ENABLED=0 go generate ./pkg/kindsys/report.go

    # Work around `main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/pkg/util/xorm`.
    # Apparently these files confuse the dependency resolution for the go builder implemented here.
    rm pkg/util/xorm/go.{mod,sum}

    # The testcase makes an API call against grafana.com:
    #
    # [...]
    # grafana> t=2021-12-02T14:24:58+0000 lvl=dbug msg="Failed to get latest.json repo from github.com" logger=update.checker error="Get \"https://raw.githubusercontent.com/grafana/grafana/main/latest.json\": dial tcp: lookup raw.githubusercontent.com on [::1]:53: read udp [::1]:36391->[::1]:53: read: connection refused"
    # grafana> t=2021-12-02T14:24:58+0000 lvl=dbug msg="Failed to get plugins repo from grafana.com" logger=plugin.manager error="Get \"https://grafana.com/api/plugins/versioncheck?slugIn=&grafanaVersion=\": dial tcp: lookup grafana.com on [::1]:53: read udp [::1]:41796->[::1]:53: read: connection refused"
    ${skipTest 1 "Request is not forbidden if from an admin" "pkg/tests/api/plugins/api_plugins_test.go"}

    # Skip a flaky test (https://github.com/NixOS/nixpkgs/pull/126928#issuecomment-861424128)
    ${skipTest 2 "it should change folder successfully and return correct result" "pkg/services/libraryelements/libraryelements_patch_test.go"}

    # Skip flaky tests (https://logs.ofborg.org/?key=nixos/nixpkgs.263185&attempt_id=5b056a17-67a7-4b74-9dc7-888eb1d6c2dd)
    ${skipTest 1 "TestIntegrationRulerAccess" "pkg/tests/api/alerting/api_alertmanager_test.go"}
    ${skipTest 1 "TestIntegrationRulePause" "pkg/tests/api/alerting/api_ruler_test.go"}

    # main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/scripts/go
    rm -r scripts/go

    # Requires making API calls against storage.googleapis.com:
    #
    # [...]
    # grafana> 2023/08/24 08:30:23 failed to copy objects, err: Post "https://storage.googleapis.com/upload/storage/v1/b/grafana-testing-repo/o?alt=json&name=test-path%2Fbuild%2FTestCopyLocalDir2194093976%2F001%2Ffile2.txt&prettyPrint=false&projection=full&uploadType=multipart": dial tcp: lookup storage.googleapis.com on [::1]:53: read udp [::1]:36436->[::1]:53: read: connection refused
    # grafana> panic: test timed out after 10m0s
    rm pkg/build/gcloud/storage/gsutil_test.go

    # Setup node_modules
    export HOME="$(mktemp -d)"
    yarn config set enableTelemetry 0
    yarn config set cacheFolder $offlineCache
    yarn --immutable-cache
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
    license = licenses.agpl3;
    homepage = "https://grafana.com";
    maintainers = with maintainers; [ offline fpletz willibutz globin ma27 Frostman ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "grafana-server";
  };
}
