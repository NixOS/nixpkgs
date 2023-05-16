{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "VictoriaMetrics";
<<<<<<< HEAD
  version = "1.93.3";
=======
  version = "1.89.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FR1EeRg9epVCnYF8QmyXGTdv3dITa3Cj50PAY500bJk=";
=======
    hash = "sha256-s5Fo0Bsy9cAoNLRMAYjNrSLJ0vX4HdbQ+T3cj6ebNPE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

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

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
