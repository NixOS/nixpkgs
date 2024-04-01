{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YQaD0eWIufqyWF3bUXBdcd9nw5smvXkyWqZlROwBxBk=";
  };

  vendorHash = "sha256-zUqsuph0fn1x4dwvBY0W0+S6SzS086SHya2ViNpDXGU=";

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
    mainProgram = "ddns-go";
  };
}
