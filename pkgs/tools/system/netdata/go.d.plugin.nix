{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "netdata-go.d.plugin";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    sha256 = "0i77nvqi3dcby0gr3b06bai170q2ibp5390qfjijrk1yqz6x6sd5";
  };

  vendorSha256 = "1q8z4smaxzqd5iwvbnkkr33c3b94rjwa3xjirwlr595g0wn93wc7";

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
