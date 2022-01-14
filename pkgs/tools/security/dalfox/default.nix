{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QSIaqHUNsVpb1qbQLIxxjoDH1DMM1XpXxWZtImMV1yM=";
  };

  vendorSha256 = "sha256-QtSWlGsbCxLpb4+TZgV0/wfSb5flGG3qHquO2maIOKU=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
