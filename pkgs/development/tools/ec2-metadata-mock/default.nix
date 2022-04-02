{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ec2-metadata-mock";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-metadata-mock";
    rev = "v${version}";
    sha256 = "sha256-sWs3chJqXL1YTHgSY0kD+PINrF4eOThOdcgSis3Mecs=";
  };

  vendorSha256 = "sha256-HbU6Y5SART+FjFyEpzv243yfo/A4yprPen5Mlhq0hbg=";

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
