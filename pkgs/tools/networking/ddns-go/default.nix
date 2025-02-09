{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "5.6.7";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s6DA7AKtJe1cXkskcXpZT1clJutyoU/fzopuPLOjg5M=";
  };

  vendorHash = "sha256-jlRY5FECeYZEndwd6JukGBTnYka1yxy666Oh9Z35nSo=";

  ldflags = [
    "-X main.version=${version}"
  ];

  # network required
  doCheck = false;

  meta = with lib;{
    homepage = "https://github.com/jeessy2/ddns-go";
    description = "Simple and easy to use DDNS";
    license = licenses.mit;
    maintainers = with maintainers; [ oluceps ];
  };
}
