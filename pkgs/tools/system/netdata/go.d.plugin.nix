{ lib, fetchFromGitHub, buildGo119Module }:
buildGo119Module rec {
  pname = "netdata-go.d.plugin";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    sha256 = "5kDc6zszVuFTDkNMuHBRwrfDnH+AdD6ULzmywtvL8iA=";
  };

  vendorSha256 = "sha256-Wv6xqzpQxlZCrVnS+g9t1qiYCkm3NfXfW8XDYA9Txxs=";

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
