{ lib
, buildGoModule
, fetchFromGitHub
, promscale
, testers
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-JizUI9XRzOEHF1kAblYQRYB11z9KWX7od3lPiRN+JNI=";
  };

  vendorHash = "sha256-lnyKsipr/f9W9LWLb2lizKGLvIbS3XnSlOH1u1B87OY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/timescale/promscale/pkg/version.Version=${version}"
    "-X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}"
  ];
  preBuild = ''
    # Without this build fails with
    # main module (github.com/timescale/promscale) does not contain package github.com/timescale/promscale/migration-tool/cmd/prom-migrator
    rm -r migration-tool
  '';
  checkPhase = ''
    runHook preCheck

    # some checks requires access to a docker daemon
    for pkg in $(getGoDirs test | grep -Ev 'testhelpers|upgrade_tests|end_to_end_tests|util'); do
      buildGoDir test $checkFlags "$pkg"
    done

    runHook postCheck
  '';

  passthru.tests.version = testers.testVersion {
    package = promscale;
    command = "promscale -version";
  };

  meta = with lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/promscale";
    changelog = "https://github.com/timescale/promscale/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ _0x4A6F anpin ];
  };
}
