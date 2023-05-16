{ lib, buildGoModule, fetchFromGitHub, testers, prometheus-pushgateway }:

buildGoModule rec {
  pname = "pushgateway";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "pushgateway";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-sJ4TTyo+A3CEUcTJv3LlUU60pc/a/PgB0Mk6R5wpTgM=";
  };

  vendorHash = "sha256-oDvFp7FYam/hsiEesfTuNgXciH4JAUKkMiECn4FPqmE=";
=======
    sha256 = "sha256-UnkSv0ZGNFqEQX+QeCySN5XeGbM2hCJGgWxry5I+3tg=";
  };

  vendorSha256 = "sha256-wEKk7Jrf14oJzP6MSRJidOUUgAbPFoBOmqPrXJg86FI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${version}"
    "-X github.com/prometheus/common/version.Branch=${version}"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=19700101-00:00:00"
  ];

  passthru.tests.version = testers.testVersion {
    package = prometheus-pushgateway;
  };

  meta = with lib; {
    description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    homepage = "https://github.com/prometheus/pushgateway";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
