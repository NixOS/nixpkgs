{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  version = "0.97-0";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "dd14b658a2f42a3b4d78682e4f4f82f730262c5c";
    sha256 = "0ckjqhj99c25h8xgyfkrd19nw5w4a7972nvba9r5faw5micjs02n";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  goPackagePath = "tailscale.com";
  modSha256 = "0anpakcqz4irwxnm0iwm7wqzh84kv3yxxdvyr38154pbd0ys5pa2";
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
