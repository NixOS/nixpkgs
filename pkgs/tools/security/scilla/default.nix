{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scilla";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1akwc/J1W1zMNqEc2Vv8wdElKbOVJ8uL3XXftGVwWnQ=";
  };

  vendorSha256 = "sha256-uTL2qr/LWmdmZipfnbzzzIx6X3fJtB1A9uYekogZN3w=";

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    homepage = "https://github.com/edoardottt/scilla";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
