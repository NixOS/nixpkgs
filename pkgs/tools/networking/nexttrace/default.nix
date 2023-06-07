{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "sjlleo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nANxqASwvYYoTTZeQpHyJfldS58rmKga+I5QYMRgvQA=";
  };
  vendorHash = "sha256-1geVqj4W9HoMCM1OkGqpYqHj2jGoGEU9Zv6fkaHBzpk=";

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xgadget-lab/nexttrace/printer.version=v${version}"
  ];

  meta = with lib; {
    description = "An open source visual route tracking CLI tool";
    homepage = "https://mtr.moe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sharzy ];
  };
}

