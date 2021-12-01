{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "godns";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "v${version}";
    sha256 = "sha256-pNy1mTP2AaeuwNvvfrHOp5v1nQgv+1DJRGYKgnx98Xo=";
  };

  vendorSha256 = "sha256-TYjkow/9W467CMyqV2SSRJAuqXGdnAgR9gtfq4vX4u0=";

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
