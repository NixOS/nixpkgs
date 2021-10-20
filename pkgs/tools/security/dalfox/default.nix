{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/tS9/VxH5r4CSmxZ7uZOgAMLRtmPs+bgPtvljOhLALc=";
  };

  vendorSha256 = "sha256-AZbzcGqje2u9waH2NGWITXpax2GCFqbIEd4uNiDmcIY=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
