{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "subjs";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lc";
    repo = pname;
    rev = "v${version}";
    sha256 = "01cip5rf35dnh3l325p03y6axyqdpf48ry4zcwiyd7hlfsglbk3j";
  };

  vendorSha256 = "1y01k8pvv7y9zb15wbk068cvkx0g83484jak2dvcvghqcf5j1fr1";

  ldflags = [ "-s" "-w" "-X main.AppVersion=${version}" ];

  meta = with lib; {
    description = "Fetcher for JavaScript files";
    longDescription = ''
      subjs fetches JavaScript files from a list of URLs or subdomains.
      Analyzing JavaScript files can help you find undocumented endpoints,
      secrets and more.
    '';
    homepage = "https://github.com/lc/subjs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
