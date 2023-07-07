{ lib, buildGoModule, fetchFromGitHub, fetchpatch, nixosTests }:

buildGoModule rec {
  pname = "VictoriaMetrics";
  version = "1.91.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZGUJfziqQCCv/9p+z8UJpvHkg6fKOIMv1tJ679f9NTo=";
  };

  vendorHash = null;

  patches = [
    (fetchpatch {
      name = "vmctl-fix-tests.patch";
      url = "https://github.com/VictoriaMetrics/VictoriaMetrics/commit/4060f3f261cb41d97df719e6c60b71be19829301.patch";
      hash = "sha256-SCeSdSLzZZodMiL7Kts0L8R5XD7TbOc5+/oidmithCY=";
    })
    (fetchpatch {
      name = "graphite-fixes-tests-for-arm.patch";
      url = "https://github.com/VictoriaMetrics/VictoriaMetrics/commit/228ea03bda0eda3507d782cb627d946843f29c30.patch";
      hash = "sha256-FnN5O9H1tNtBs5Fr4tXrnyted8SZwX82ZdBmeHlIQ2Y=";
    })
  ];

  postPatch = ''
    # main module (github.com/VictoriaMetrics/VictoriaMetrics) does not contain package
    # github.com/VictoriaMetrics/VictoriaMetrics/app/vmui/packages/vmui/web
    #
    # This appears to be some kind of test server for development purposes only.
    rm -f app/vmui/packages/vmui/web/{go.mod,main.go}

    # Increase timeouts in tests to prevent failure on heavily loaded builders
    substituteInPlace lib/storage/storage_test.go \
      --replace "time.After(10 " "time.After(120 " \
      --replace "time.NewTimer(30 " "time.NewTimer(120 " \
      --replace "time.NewTimer(time.Second * 10)" "time.NewTimer(time.Second * 120)" \
  '';

  ldflags = [ "-s" "-w" "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${version}" ];

  preCheck = ''
    # `lib/querytracer/tracer_test.go` expects `buildinfo.Version` to be unset
    export ldflags=''${ldflags//=${version}/=}
  '';

  passthru.tests = { inherit (nixosTests) victoriametrics; };

  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ yorickvp ivan ];
    changelog = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v${version}";
    mainProgram = "victoria-metrics";
  };
}
