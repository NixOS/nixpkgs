{ stdenv, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "pushgateway-${version}";
  version = "0.8.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/pushgateway";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "pushgateway";
    sha256 = "1mzwkxnznv6wzy7dc8rksa8gr7z92plrzls8gb8rk432zfqcbv6a";
  };

  buildUser = "nix@nixpkgs";
  buildDate = "19700101-00:00:00";

  buildFlagsArray = ''
    -ldflags=
        -X github.com/prometheus/pushgateway/vendor/github.com/prometheus/common/version.Version=${version}
        -X github.com/prometheus/pushgateway/vendor/github.com/prometheus/common/version.Revision=${rev}
        -X github.com/prometheus/pushgateway/vendor/github.com/prometheus/common/version.Branch=${rev}
        -X github.com/prometheus/pushgateway/vendor/github.com/prometheus/common/version.BuildUser=${buildUser}
        -X github.com/prometheus/pushgateway/vendor/github.com/prometheus/common/version.BuildDate=${buildDate}
        -X main.goVersion=${stdenv.lib.getVersion go}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export PATH=$PATH:$bin/bin

    pushgateway --help

    # Make sure our -X options were included in the build
    for s in ${version} ${rev} ${buildUser} ${buildDate}; do
      pushgateway --version 2>&1 | fgrep -q -- "$s" || { echo "pushgateway --version output missing $s"; exit 1; }
    done
  '';

  meta = with stdenv.lib; {
    description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    homepage = https://github.com/prometheus/pushgateway;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ivan ];
    platforms = platforms.unix;
  };
}
