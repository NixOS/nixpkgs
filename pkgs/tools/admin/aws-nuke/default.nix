{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aws-nuke";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "rebuy-de";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UxisIhV23shgDC+9uN/YSPTHNa/hiPu8Rl06vxjJWNc=";
  };

  vendorSha256 = "sha256-sdEaYHH5ZsxF4aKyFMjh5YZVwx0dEbSY0S8R3L10ywM=";

  preBuild = ''
    if [ "x$outputHashAlgo" != "x" ]; then
      # Only `go generate` when fetching the go mod vendor code
      go generate ./...
    fi
  '';

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Nuke a whole AWS account and delete all its resources";
    homepage = "https://github.com/rebuy-de/aws-nuke";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc ];
  };
}
