{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "godns";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "v${version}";
    sha256 = "sha256-0aE+XcRqk/3/auscVdqdzehrpM6CeSdAJTugHXY8rek=";
  };

  vendorSha256 = "sha256-vhByl9oJjFIvOskAgLubZ5RCcitKd2jjxi8D9nU6850=";

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
