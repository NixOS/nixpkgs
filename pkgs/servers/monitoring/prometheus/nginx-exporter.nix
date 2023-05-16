{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginx_exporter";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    rev = "v${version}";
    sha256 = "sha256-glKjScJoJnFEm7Z9LAVF51haeyHB3wQ946U8RzJXs3k=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-YyMySHnrjBHm3hRNJDwWBs86Ih4S5DONYuwlQ3FBjkA=";
=======
  vendorSha256 = "sha256-YyMySHnrjBHm3hRNJDwWBs86Ih4S5DONYuwlQ3FBjkA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginx; };

  meta = with lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz willibutz globin ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
