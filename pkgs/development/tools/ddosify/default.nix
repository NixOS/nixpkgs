{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ddosify";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z7jYnEZSHh/Omg5DMNFzuPhV1d8lZSy8I+8tM86O43s=";
  };

  vendorSha256 = "sha256-VWWik7oovVJq0J/tj/2Mm5QtvRkJLtMROJhRC2JFZdw=";

  # triggers a different set of tests that seems to be interactive and fail (no url target defined)
  ldflags = [
    "-s -w"
    "-X main.GitVersion=${version}"
  ];

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
