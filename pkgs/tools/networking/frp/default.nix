{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "frp";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JutR1yrxbwhfcw6qTh493yVeo7KzLl83himPTX8FJlA=";
  };

  vendorSha256 = "sha256-HOfcVPrJ6TBrhToqYN2CJ0i3re95awrIxQk2Mm8x3DU=";

  doCheck = false;

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
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
