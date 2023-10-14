{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yOi2dowde2hTZOWq1Trpf3tAypA6bD6SawP5geqK7Ms=";
  };

  vendorHash = "sha256-e4mmUneFZCsteSrxfSeeky/pFc0sgNs0eRVnZQuG1ZI=";

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
