{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H6W+C5twXit7Z9hLIJKAftbnvYDA9HAb9tR6yeQGRKI=";
  };

  vendorSha256 = "sha256-QOMLwDDvrDQAaK4M4QhBFTGD1CzblkDoA3ZqtCoRHtQ=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
