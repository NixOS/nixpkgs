{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e6mB1Z/PqxD3TbcfoPpWUrgDebcD+nadiTtx3reGqvk=";
  };

  vendorSha256 = "sha256-mXzI3NF1afMvQ4STPpbehoarfOT35P01IotXPVYNnio=";

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
