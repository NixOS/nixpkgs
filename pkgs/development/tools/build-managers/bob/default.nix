{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bob";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "benchkram";
    repo = pname;
    rev = version;
    hash = "sha256-yPdAf/j/vpQ2j+Zp8D7us7yaiDs47sKFPHZgggDjT3w=";
  };

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  vendorHash = "sha256-6wAbwZKm8RTMt2Wm90N3AYZREipdo7Dq+XTWsLANd88=";

  excludedPackages = [ "example/server-db" "test/e2e" "tui-example" ];

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "A build system for microservices";
    homepage = "https://bob.build";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zuzuleinen ];
  };
}
