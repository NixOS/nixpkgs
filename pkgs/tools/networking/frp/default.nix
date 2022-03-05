{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "frp";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tqdrYrIWbmRn+5iAZKd9GlcmFNQnh3yNxZ95As7+v5Q=";
  };

  vendorSha256 = "sha256-NPnchl+N6DeqMhsOIw2MYD/i2IZzHS9ZqbUOeulgb90=";

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
