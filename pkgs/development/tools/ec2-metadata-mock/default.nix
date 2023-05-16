{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ec2-metadata-mock";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-metadata-mock";
    rev = "v${version}";
    sha256 = "sha256-hYyJtkwAzweH8boUY3vrvy6Ug+Ier5f6fvR52R+Di8o=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-T45abGVoiwxAEO60aPH3hUqiH6ON3aRhkrOFcOi+Bm8=";
=======
  vendorSha256 = "sha256-T45abGVoiwxAEO60aPH3hUqiH6ON3aRhkrOFcOi+Bm8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
