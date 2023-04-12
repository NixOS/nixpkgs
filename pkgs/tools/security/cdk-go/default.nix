{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cdk-go";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "cdk-team";
    repo = "CDK";
    rev = "refs/tags/v${version}";
    hash = "sha256-jgGOSlhlLO1MU1mHWZgw+ov4IrZwMo2GdG6L25ah9Z8=";
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
