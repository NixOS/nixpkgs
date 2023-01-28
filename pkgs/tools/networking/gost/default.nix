{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gost";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "ginuerzh";
    repo = "gost";
    rev = "v${version}";
    sha256 = "1mxgjvx99bz34f132827bqk56zgvh5rw3h2xmc524wvx59k9zj2a";
  };

  vendorSha256 = "1cgb957ipkiix3x0x84c77a1i8l679q3kqykm1lhb4f19x61dqjh";

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

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A simple tunnel written in golang";
    homepage = "https://github.com/ginuerzh/gost";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
  };
}
