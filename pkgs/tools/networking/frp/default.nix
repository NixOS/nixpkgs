{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "frp";
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rajyd6p17a18d6gsgn600zi7lp4dv2pjw1bp1sssdwb5qca4dg9";
  };

  modSha256 = "15wdnzb5q1rsqsmmgvhakkk4w7l184kkafhv69iwdqjdcaddd9y2";

  subPackages = [ "cmd/frpc" "cmd/frps" ];

  meta = with lib; {
    description = "Fast reverse proxy";
    longDescription = ''
      frp is a fast reverse proxy to help you expose a local server behind a
      NAT or firewall to the Internet. As of now, it supports TCP and UDP, as
      well as HTTP and HTTPS protocols, where requests can be forwarded to
      internal services by domain name. frp also has a P2P connect mode.
    '';
    homepage = "https://github.com/fatedier/frp";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
