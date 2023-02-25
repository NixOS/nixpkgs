{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pO1FXlkaQveDIfMSWiLB9QvVxmFJixc/HHcEuhg5KmY=";
  };

  vendorHash = "sha256-zDKByBISZNRb4sMCrHKGlp4EBtifBfj92tygcaBH/Fc=";

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
