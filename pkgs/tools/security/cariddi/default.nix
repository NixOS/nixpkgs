{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oM4A4chSBTiCMr3bW0AvjAFlyuqvKKKY2Ji4PYRsUqA=";
  };

  vendorHash = "sha256-EeoJssX/OkIJKltANfvMirvDVmVVIe9hDj+rThKpd10=";

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    changelog = "https://github.com/edoardottt/cariddi/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
