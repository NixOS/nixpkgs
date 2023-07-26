{ buildGoModule
, fetchFromGitHub
, goss
, nix-update-script
, lib
, testers
}:

buildGoModule rec {
  pname = "goss";

  # Don't forget to update dgoss to the same version.
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "goss-org";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dpMTUBMEG5tDi7E6ZRg1KHqIj5qDlvwfwJEgq/5z7RE=";
  };

  vendorHash = "sha256-n+k7f9e2iqf4KrcDkzX0CWk+Bq2WE3dyUEid4PTP1FA=";

  CGO_ENABLED = 0;
  ldflags = [
    "-s" "-w" "-X main.version=v${version}"
  ];

  checkFlags = [
    # Prometheus tests are skipped upstream
    # See https://github.com/goss-org/goss/blob/master/ci/go-test.sh
    "-skip" "^TestPrometheus"
  ];

  passthru = {
    tests.version = testers.testVersion {
      command = "goss --version";
      package = goss;
      version = "v${version}";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/goss-org/goss/";
    changelog = "https://github.com/goss-org/goss/releases/tag/v${version}";
    description = "Quick and easy server validation";
    longDescription = ''
      Goss is a YAML based serverspec alternative tool for validating a server’s configuration.
      It eases the process of writing tests by allowing the user to generate tests from the current system state.
      Once the test suite is written they can be executed, waited-on, or served as a health endpoint.
    '';
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hyzual jk anthonyroussel ];
  };
}
