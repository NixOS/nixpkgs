{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bob";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "benchkram";
    repo = pname;
    rev = version;
    hash = "sha256-JG1fysCqqd/MwpNhKJwLr4cTGq4/88f9OMMapb+r3bc=";
  };

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  vendorHash = "sha256-R+zXGR5isoo76oc4lsFf9uCM0Kyi8dQiKEg4BUxtv+k=";

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
