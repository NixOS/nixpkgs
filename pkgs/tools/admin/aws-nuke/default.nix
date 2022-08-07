{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aws-nuke";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "rebuy-de";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4G+/VNTp5Bb1TAcqb//LUvwEGDrXRNNka4X52jCH+Rs=";
  };

  vendorSha256 = "sha256-p+pcVvu+d/scel8VVCFqZccwfOTOyKeud3gKLqpWE1g=";

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
