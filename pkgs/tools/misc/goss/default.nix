{ bash
, buildGoModule
, fetchFromGitHub
, getent
, goss
, lib
, makeWrapper
, nix-update-script
, nixosTests
, stdenv
, systemd
, testers
}:

buildGoModule rec {
  pname = "goss";

  # Don't forget to update dgoss to the same version.
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "goss-org";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dH052t30unWmrFTZK5niXNvbg1nngzWY7mwuZr4ULbM=";
  };

  vendorHash = "sha256-4fEEz/c/xIeWxIzyyjwgSn2/2FWLA2tIedK65jGgYhY=";

  CGO_ENABLED = 0;
  ldflags = [
    "-s" "-w" "-X main.version=v${version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  checkFlags = [
    # Prometheus tests are skipped upstream
    # See https://github.com/goss-org/goss/blob/master/ci/go-test.sh
    "-skip" "^TestPrometheus"
  ];

  postInstall = let
    runtimeDependencies = [ bash getent ]
      ++ lib.optionals stdenv.isLinux [ systemd ];
  in ''
    wrapProgram $out/bin/goss \
      --prefix PATH : "${lib.makeBinPath runtimeDependencies}"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) goss;
      version = testers.testVersion {
        command = "goss --version";
        package = goss;
        version = "v${version}";
      };
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
    mainProgram = "goss";
    maintainers = with maintainers; [ hyzual jk anthonyroussel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
