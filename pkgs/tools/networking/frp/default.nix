{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "frp";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n1b7rr6njblz3rmsdl6xng4swlagg2z3jnik0gnajiq3w8ajwdj";
  };

  vendorSha256 = "18d9478ndzywwmh0jsxcb4i2rqyn3vzrgwflqrsv7krijalknsc9";

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
    maintainers = with maintainers; [ filalex77 ];
  };
}
