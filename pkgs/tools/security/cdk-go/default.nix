{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cdk-go";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "cdk-team";
    repo = "CDK";
    rev = "v${version}";
    sha256 = "1zz9jaz5nlvs52nqlaisivrnz7lz8g48qii0n2s1783a5jpkk9ml";
  };

  vendorSha256 = "0sn709mbhfymwwfdqc5xpdz2lgimqx3xycfmq24vbfmlh8wqcs7l";

  # At least one test is outdated
  doCheck = false;

  meta = with lib; {
    description = "Container penetration toolkit";
    homepage = "https://github.com/cdk-team/CDK";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "cdk";
  };
}
