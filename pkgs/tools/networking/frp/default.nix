{ buildGoModule, lib, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "frp";
  version = "0.51.3";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ijcYSuB91I9lD4qx6ohVFDQgTE0+FTQ5Hr1heNwKyUo=";
  };

  vendorHash = "sha256-DFQ59E24LR5/qodtge0EsqajvrjPN0otpxGB8JQ0ERw=";

  doCheck = false;

  subPackages = [ "cmd/frpc" "cmd/frps" ];

  passthru.tests = {
    frp = nixosTests.frp;
  };

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
