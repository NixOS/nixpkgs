{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cdk-go";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "cdk-team";
    repo = "CDK";
    rev = "refs/tags/v${version}";
    hash = "sha256-0cg2o98BcE4H6EW/yAkJOJtIJXEq2cFG6pNaRPtQofo=";
  };

  vendorHash = "sha256-aJN/d/BxmleRXKw6++k6e0Vb0Gs5zg1QfakviABYTog=";

  # At least one test is outdated
  doCheck = false;

  meta = with lib; {
    description = "Container penetration toolkit";
    homepage = "https://github.com/cdk-team/CDK";
    changelog = "https://github.com/cdk-team/CDK/releases/tag/v${version}";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "cdk";
    broken = stdenv.isDarwin; # needs to update gopsutil to at least v3.21.3 to include https://github.com/shirou/gopsutil/pull/1042
  };
}
