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

  vendorSha256 = "sha256-F0uIV4T/dCqPY/gsSOrzJTxFGlDh9NfxKhJxrftj0Lo=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
