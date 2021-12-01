{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "godns";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "v${version}";
    sha256 = "sha256-C2Auk0BJLhW8r4cnmoZiUddb8rcZqND5fER9L+3ooH4=";
  };

  vendorSha256 = "sha256-/egdqQCkbmrxuQ3vPfHOtHxAgW143Y2eZEzKAsBVmaI=";

  # Some tests require internet access, broken in sandbox
  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "A dynamic DNS client tool supports AliDNS, Cloudflare, Google Domains, DNSPod, HE.net & DuckDNS & DreamHost, etc";
    homepage = "https://github.com/TimothyYe/godns";
    license = licenses.asl20;
    maintainers = with maintainers; [ yinfeng ];
  };
}
