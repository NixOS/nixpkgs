{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.2.3.1";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    rev = "v${version}";
    sha256 = "sha256-uY3Cjemv+iFOrWm7lXzRprIljqHCLWOF6DyDURrH39g=";
  };
  vendorHash = "sha256-sugEN7sKBwEKsfX1MBwOiyH1aq1995HL+Yv7Q8XaPAo=";

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nxtrace/NTrace-core/config.Version=v${version}"
  ];

  postInstall = ''
    mv $out/bin/NTrace-core $out/bin/nexttrace
  '';

  meta = with lib; {
    description = "An open source visual route tracking CLI tool";
    homepage = "https://mtr.moe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sharzy ];
  };
}

