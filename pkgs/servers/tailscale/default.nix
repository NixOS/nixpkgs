{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  # Tailscale uses "git describe" as version numbers. 0.99.1-0 means
  # "tag v0.99.1 plus 0 commits", which corresponds to rev="v0.99.1"
  # below.
  version = "0.99.1-0";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v0.99.1";
    sha256 = "1kq4x5xknv0qq6n78xj5wjbf6svbdyw4nzs7z5gjb3ylj2vl97pb";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  goPackagePath = "tailscale.com";
  vendorSha256 = "0yf2zdpd12w4qf4sbv7bkr40hw5faqynr6lb84v7w6v0az0nfzds";
  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  postInstall = ''
    wrapProgram $out/bin/tailscaled --prefix PATH : ${
      lib.makeBinPath [ iproute iptables ]
    }
  '';

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson mbaillie ];
  };
}
