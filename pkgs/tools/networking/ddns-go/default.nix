{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w9/5n5QKx+pNiA0wBTjjwllsAvsGUH53buwmx2CIZIg=";
  };

  vendorHash = "sha256-azsXfWa4w3wZaiy9AKy7UPOybikubcJvLsXthYedmbY=";

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
