{ lib, buildGoModule, fetchFromGitHub, go, prometheus-sql-exporter, testers }:

buildGoModule rec {
  pname = "sql_exporter";
<<<<<<< HEAD
  version = "0.4.7";
=======
  version = "0.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "justwatchcom";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-aSygfs5jVc1CTb+uj16U//99ypP4kixz7gqDvxIxxfM=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-A3hMSnfxiEgFYueARuldEHT/5ROCIwWjqQj2FdkVYqo=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = let t = "github.com/prometheus/common/version"; in
    [
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=${src.rev}"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  passthru.tests.version = testers.testVersion {
    package = prometheus-sql-exporter;
    command = "sql_exporter -version";
  };

  meta = with lib; {
    description = "Flexible SQL exporter for Prometheus";
    homepage = "https://github.com/justwatchcom/sql_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
