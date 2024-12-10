{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "vt-cli";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-qwfrNm6XfoOtlpAI2aAaoivkp3Xsw9LnVtwnZ1wXGUs=";
  };

  vendorHash = "sha256-XN6dJpoJe9nJn+Tr9SYD64LE0XFiO2vlpdyI9SrZZjQ=";

  ldflags = [
    "-X github.com/VirusTotal/vt-cli/cmd.Version=${version}"
  ];

  subPackages = [ "vt" ];

  meta = with lib; {
    description = "VirusTotal Command Line Interface";
    homepage = "https://github.com/VirusTotal/vt-cli";
    changelog = "https://github.com/VirusTotal/vt-cli/releases/tag/${version}";
    license = licenses.asl20;
    mainProgram = "vt";
    maintainers = with maintainers; [ dit7ya ];
  };
}
