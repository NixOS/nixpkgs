{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.2.1.1";

  src = fetchFromGitHub {
    owner = "sjlleo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B3NHY4wYCa3lR3XPqhjcrgf9iA4Bz/8bKrwxdNSa1Bk=";
  };
  vendorHash = "sha256-8etZelvdUmHNWC0FnSX9oO3reuhB7xIzd/KxPTt6Szc=";

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xgadget-lab/nexttrace/config.Version=v${version}"
  ];

  meta = with lib; {
    description = "An open source visual route tracking CLI tool";
    homepage = "https://mtr.moe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sharzy ];
  };
}

