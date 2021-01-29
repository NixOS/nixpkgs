{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "frp";
  version = "0.35.1";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QnD8Yo1GLlOuCnYgzAIGW8JQ5yihmAZGqDFJ412L+W0=";
  };

  vendorSha256 = "sha256-odZPXLn5la2x9QIlT3g7+Rxb9tXGhjTycEvJPUPbM2s=";

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
