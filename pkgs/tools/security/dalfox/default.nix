{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+Jr2pWV3iImKVnXH8mQXauHOh3uJChUe22U4JzIotD0=";
  };

  vendorSha256 = "sha256-4ot9qvTsUMxbcbu1y+5Tkvgo3t0MWA1EPSGqM0CM2DU=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
