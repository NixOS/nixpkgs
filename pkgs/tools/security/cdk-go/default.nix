{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cdk-go";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "cdk-team";
    repo = "CDK";
    rev = "v${version}";
    sha256 = "sha256-Ngv+/b9D27ERwjNIC3s3ZBPkV10G+tT8QW8YMOgb8aA=";
  };

  vendorSha256 = "sha256-9Q7f3keMUEI2cWal2dvp4b8kvTZVM1Cf4iTvH9yCyX0=";

  # At least one test is outdated
  doCheck = false;

  meta = with lib; {
    description = "Container penetration toolkit";
    homepage = "https://github.com/cdk-team/CDK";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "cdk";
    broken = stdenv.isDarwin; # needs to update gopsutil to at least v3.21.3 to include https://github.com/shirou/gopsutil/pull/1042
  };
}
