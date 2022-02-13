{ lib
, buildGoModule
, fetchFromGitHub
, promscale
, testVersion
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-snbQVkJ4J5ElVNfHuSfb7VCZ64TqJ8Lx5uUaJPqBHl4=";
  };

  patches = [
    ./0001-remove-jaeger-test-dep.patch
  ];

  vendorSha256 = "sha256-1t4WNoJrfKTtrpwi9p+L1WQR7mTsD70CRW+RYT7E9Lo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/timescale/promscale/pkg/version.Version=${version}"
    "-X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}"
  ];

  checkPhase = ''
    runHook preCheck

    # some checks requires access to a docker daemon
    for pkg in $(getGoDirs test | grep -Ev 'testhelpers|upgrade_tests|end_to_end_tests|util'); do
      buildGoDir test $checkFlags "$pkg"
    done

    runHook postCheck
  '';

  passthru.tests.version = testVersion {
    package = promscale;
    command = "promscale -version";
  };

  meta = with lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/promscale";
    changelog = "https://github.com/timescale/promscale/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
