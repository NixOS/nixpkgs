{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-o5xJwbdYeFF3jWTy/zvswB9dFp/fxtgZB5a+c7cc2OQ=";
  };

  vendorSha256 = "sha256-rzbf/au2qrdoBowsw7DbeCcBbF42bqJDnuKC1sSFxho=";

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
