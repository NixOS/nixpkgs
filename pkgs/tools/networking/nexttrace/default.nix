{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    rev = "v${version}";
    sha256 = "sha256-UD6+oFXYk5VWD9MZdE3ECnyYJSe7v88D9gkIAj+e7Bw=";
  };
  vendorHash = "sha256-2lDkNbsAgEMSKK7ODpjJEL0ZM4N1khzGuio1645Xxqo=";

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

