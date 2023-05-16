{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "postgres_exporter";
<<<<<<< HEAD
  version = "0.13.2";
=======
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-K0B6EsRCWznYf4xS+9T4HafOSUPHCNsu2ZSIVXneGyk=";
  };

  vendorHash = "sha256-0MQS42/4iImtq3yBGVCe0BwV0HiJCo7LVEAbsKltE4g=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [ "-s" "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];
=======
    sha256 = "sha256-eY9/a+uFJJ8lT+0ZGa+ExjKf0V6JOqI3l1sZbfQEXOc=";
  };

  vendorSha256 = "sha256-sMWprCRUvF6voLM3GjTq9tId1GoCPac/RE6hXL+LBEE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postgres; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ma27 ];
  };
}
