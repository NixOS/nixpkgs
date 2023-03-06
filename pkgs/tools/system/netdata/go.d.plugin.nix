{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "netdata-go-plugins";
  version = "0.51.2";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    sha256 = "sha256-u87kTNM1oAmJRtm/iEESjVvQ9qEpFCGqRT8M+iVEwlI=";
  };

  vendorSha256 = "sha256-QB+Sf7biNPD8/3y9pFxOJZXtc6BaBcQsUGP7y9Wukwg=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    mkdir -p $out/lib/netdata/conf.d
    cp -r config/* $out/lib/netdata/conf.d
  '';

  meta = with lib; {
    description = "Netdata orchestrator for data collection modules written in go";
    homepage = "https://github.com/netdata/go.d.plugin";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
