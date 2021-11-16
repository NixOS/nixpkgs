{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ddosify";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kccn6tnJfy4mx0hyBi2ggPvNPu/iQgGBMxQ6hsYy7So=";
  };

  vendorSha256 = "sha256-TY8shTb77uFm8/yCvlIncAfq7brWgnH/63W+hj1rvqg=";

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
