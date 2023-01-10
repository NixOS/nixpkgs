{ buildGoModule, fetchFromGitHub, lib, nix-update-script }:

buildGoModule rec {
  pname = "godns";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "v${version}";
    sha256 = "sha256-ZTp7MQTl1FbahmnStXFML4KeL736CXY5rE2gilP3txg=";
  };

  vendorSha256 = "sha256-PGqknRGtN0XRGPnAsWzQrlJZG5BzQIhlSysGefkxysE=";

  # Some tests require internet access, broken in sandbox
  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A dynamic DNS client tool supports AliDNS, Cloudflare, Google Domains, DNSPod, HE.net & DuckDNS & DreamHost, etc";
    homepage = "https://github.com/TimothyYe/godns";
    license = licenses.asl20;
    maintainers = with maintainers; [ yinfeng ];
  };
}
