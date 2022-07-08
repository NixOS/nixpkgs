{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cdk-go";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "cdk-team";
    repo = "CDK";
    rev = "v${version}";
    sha256 = "sha256-0RDCg0UYCj0hlCM3BgOzKfuOulQVI/C9Mz6g5TJ5B1Y=";
  };

  vendorSha256 = "sha256-fEGU8egsEAYStsYiTi1SFyBY3qBrrOiPuZn1eZ+YCVM=";

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
