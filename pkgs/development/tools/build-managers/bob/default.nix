{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bob";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "benchkram";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JG1fysCqqd/MwpNhKJwLr4cTGq4/88f9OMMapb+r3bc=";
  };

  vendorSha256 = "sha256-R+zXGR5isoo76oc4lsFf9uCM0Kyi8dQiKEg4BUxtv+k=";

  excludedPackages = ["example/server-db" "test/e2e"];

  doCheck = false;

  meta = with lib; {
    description = "A build system for microservices";
    homepage    = "https://bob.build";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = [ "zuzuleinen" ];
  };
}

