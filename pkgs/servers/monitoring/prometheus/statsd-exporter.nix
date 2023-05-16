{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "statsd_exporter";
<<<<<<< HEAD
  version = "0.24.0";
=======
  version = "0.23.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-I0/UX4Tpbd2cfsMQQ3gAGfJ3Bgr+JxRARNmV2v2mLeM=";
  };

  vendorHash = "sha256-cTAjOCP0qWMIKa0xGSK7Id+Oqz3ompDlwAqwub9oNWI=";
=======
    hash = "sha256-JbRkLRXTQo40wBynfG6BRR4+yPqy7VLJ33vsjus5okg=";
  };

  vendorHash = "sha256-YzcgEQ1S2qn7v2SVSBiodprtc+D4cSZOFBJwpq3jz8Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    changelog = "https://github.com/prometheus/statsd_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
