{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ddosify";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-p138Jg5jqflabroaBy3Dj9K9cif0tcM7r9dluf4tsH4=";
  };

  vendorHash = "sha256-3y5ppTtvGqwWhgnVBpP4gf26DHKPnSNYK4jfhBiYDwY=";

  ldflags = [
    "-s" "-w"
    "-X main.GitVersion=${version}"
    "-X main.GitCommit=unknown"
    "-X main.BuildDate=unknown"
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
