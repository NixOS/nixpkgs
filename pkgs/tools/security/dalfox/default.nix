{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JNEKFbhJlBUvAzqd1UODWv8HIo5LDVPvFfwmztsRW2o=";
  };

  vendorSha256 = "sha256-PVtUC8UfUBGL7m1SsMK48Bcm9poCSFcPWJs1e+/UfSI=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
