{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "godns";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "v${version}";
    sha256 = "sha256-ia0FmV2KlFPh9gmKOqVxiStgmBbX9vUIc7KllpUt44Q=";
  };

  vendorSha256 = "sha256-FZLDaMrPEyoTGFmGBlpqPWsMuobqwkBaot5qjcRJe9w=";

  # Some tests require internet access, broken in sandbox
  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  meta = with lib; {
    description = "A dynamic DNS client tool supports AliDNS, Cloudflare, Google Domains, DNSPod, HE.net & DuckDNS & DreamHost, etc";
    homepage = "https://github.com/TimothyYe/godns";
    license = licenses.asl20;
    maintainers = with maintainers; [ yinfeng ];
  };
}
