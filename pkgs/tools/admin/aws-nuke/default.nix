{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aws-nuke";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "rebuy-de";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e5EtIRIM0Gz2BXGaZx3jiO+MNdD1Eh9h7U+aZSBVFGc=";
  };

  vendorSha256 = "sha256-tRFYZ0GBJDumvfOYMJDcYqTlTn5do3trZ1gXafuDVi4=";

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
