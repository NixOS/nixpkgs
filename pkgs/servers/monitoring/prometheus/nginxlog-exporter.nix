{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginxlog_exporter";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "martin-helmich";
    repo = "prometheus-nginxlog-exporter";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-UkXrVHHHZ9mEgsMUcHu+wI6NZFw4h3X4atDBjpBcz8E=";
  };

  vendorHash = "sha256-RzqfmP1d3zqageiGSr+CxSJQxAXmOKRCwj/7KO2f3EE=";
=======
    sha256 = "sha256-W+cLJUsg49Fwo2IsJjo0QZ0NLNy/H7E35Yjr7bsHAkQ=";
  };

  vendorSha256 = "sha256-Bdyk+yNVcxPDzxJQSE34HJCryWQSXa8748gJ5Fu+gP4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginxlog; };

  meta = with lib; {
    description = "Export metrics from Nginx access log files to Prometheus";
    homepage = "https://github.com/martin-helmich/prometheus-nginxlog-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut ];
  };
}
