{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ec2-metadata-mock";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-metadata-mock";
    rev = "v${version}";
    sha256 = "sha256-k4YzG4M+r6BHc4DdAMXoUvVDTJqmzr8vIL1J6kbJBeY=";
  };

  vendorSha256 = "sha256-bI1W6KdXIq5HsoXDOq93Le2vePAAgvqy/lXm/N1F+yU=";

  postInstall = ''
    mv $out/bin/{cmd,ec2-metadata-mock}
  '';

  meta = with lib; {
    description = "Amazon EC2 Metadata Mock";
    homepage = "https://github.com/aws/amazon-ec2-metadata-mock";
    license = licenses.asl20;
    maintainers = with maintainers; [ ymatsiuk ];
  };
}
