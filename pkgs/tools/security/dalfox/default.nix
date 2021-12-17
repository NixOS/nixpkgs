{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4jqlMZ6/5m12+ZT0HCtskXq6jlcsQq05Vem+jw82RFs=";
  };

  vendorSha256 = "sha256-MoOnRsL8DO7Mx7JzvpnEOiqoLEyBPi2cRiQ2m+460V4=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
