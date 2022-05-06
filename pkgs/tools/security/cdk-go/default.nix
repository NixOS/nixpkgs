{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cdk-go";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "cdk-team";
    repo = "CDK";
    rev = "v${version}";
    sha256 = "sha256-XzUSiE03ZbP75ewwBJFwZE0aKNlOFprezeD26japLD8=";
  };

  vendorSha256 = "sha256-mP49DmOHvS8ewQG7I1J5OEmAOkHEFJfAsEPeiaRBpWc=";

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
