{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ddosify";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-n9xKg8RN2o20dTsV8a0tAJjmvAlwZ7TF2cTrXx+f49k=";
  };

  vendorSha256 = "sha256-lbo9P2UN9TmUAqyhFdbOHWokoAogVQZihpcOlhmumxU=";

  ldflags = [
    "-s -w"
    "-X main.GitVersion=${version}"
  ];

  # TestCreateHammerMultipartPayload error occurred - Get "https://upload.wikimedia.org/wikipedia/commons/b/bd/Test.svg"
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/ddosify -version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "High-performance load testing tool, written in Golang";
    homepage = "https://ddosify.com/";
    changelog = "https://github.com/ddosify/ddosify/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
