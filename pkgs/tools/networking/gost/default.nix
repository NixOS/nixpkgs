{ stdenv, lib, fetchFromGitHub, buildGoModule, fetchpatch }:

buildGoModule rec {
  pname = "gost";
  version = "2.11.5-unstable-2024-02-02";

  src = fetchFromGitHub {
    owner = "ginuerzh";
    repo = "gost";
    rev = "fd57e80709aba9581757b1cd63b7d8f75e2385d2";
    sha256 = "sha256-GkXsiUcH5hppgkkt4ddVMLm5riUDORVhjWBGHZXti5A=";
  };

  patches = [
    # Bump quic-go to v0.41.0 for go 1.22 compatibility.
    (fetchpatch {
      url = "https://github.com/ginuerzh/gost/pull/1016/commits/c2e3f7e493bbb6ff1bc348f36e1a148d9d0c16ad.patch";
      hash = "sha256-9OtuPIzzCymMAVbrDuhhPcxcac69gjAUm4ykXbH/pbo=";
    })
  ];

  vendorHash = "sha256-mq95eHyW8XkqyLApSqVB3bv5VFSu6FuPap/mTQj8a9M=";

  postPatch = ''
    substituteInPlace http2_test.go \
      --replace "TestH2CForwardTunnel" "SkipH2CForwardTunnel" \
      --replace "TestH2ForwardTunnel" "SkipH2ForwardTunnel"

    substituteInPlace resolver_test.go \
      --replace '{NameServer{Addr: "1.1.1.1"}, "github", true},' "" \
      --replace '{NameServer{Addr: "1.1.1.1"}, "github.com", true},' "" \
      --replace '{NameServer{Addr: "1.1.1.1:53"}, "github.com", true},' "" \
      --replace '{NameServer{Addr: "1.1.1.1:53", Protocol: "tcp"}, "github.com", true},' "" \
      --replace '{NameServer{Addr: "1.1.1.1:853", Protocol: "tls"}, "github.com", true},' "" \
      --replace '{NameServer{Addr: "1.1.1.1:853", Protocol: "tls", Hostname: "cloudflare-dns.com"}, "github.com", true},' "" \
      --replace '{NameServer{Addr: "https://cloudflare-dns.com/dns-query", Protocol: "https"}, "github.com", true},' "" \
      --replace '{NameServer{Addr: "https://1.0.0.1/dns-query", Protocol: "https"}, "github.com", true},' ""

    # Skip TestShadowTCP, TestShadowUDP: #70 #71 #72 #78 #83 #85 #86 #87 #93
    substituteInPlace ss_test.go \
      --replace '{url.User("xchacha20"), url.UserPassword("xchacha20", "123456"), false},' "" \
      --replace '{url.UserPassword("xchacha20", "123456"), url.User("xchacha20"), false},' "" \
      --replace '{url.UserPassword("xchacha20", "123456"), url.UserPassword("xchacha20", "abc"), false},' "" \
      --replace '{url.UserPassword("CHACHA20-IETF-POLY1305", "123456"), url.UserPassword("CHACHA20-IETF-POLY1305", "123456"), true},' "" \
      --replace '{url.UserPassword("AES-128-GCM", "123456"), url.UserPassword("AES-128-GCM", "123456"), true},' "" \
      --replace '{url.User("AES-192-GCM"), url.UserPassword("AES-192-GCM", "123456"), false},' "" \
      --replace '{url.UserPassword("AES-192-GCM", "123456"), url.User("AES-192-GCM"), false},' "" \
      --replace '{url.UserPassword("AES-192-GCM", "123456"), url.UserPassword("AES-192-GCM", "abc"), false},' "" \
      --replace '{url.UserPassword("AES-256-GCM", "123456"), url.UserPassword("AES-256-GCM", "123456"), true},' ""
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Simple tunnel written in golang";
    homepage = "https://github.com/ginuerzh/gost";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
    mainProgram = "gost";
  };
}
