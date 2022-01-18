{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ssmsh";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "bwhaley";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WZ2glv/f4LwTK/G8QdaVRIAHvgGLPLPL8xjAg/kUokQ=";
  };

  vendorSha256 = "sha256-17fmdsfOrOaySPsXofLzz0+vmiemg9MbnWhRoZ67EuQ=";

  doCheck = true;

  ldflags = [ "-w" "-s" "-X main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/bwhaley/ssmsh";
    description = "An interactive shell for AWS Parameter Store";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
  };
}
