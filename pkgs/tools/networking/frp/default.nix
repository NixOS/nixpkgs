{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "frp";
<<<<<<< HEAD
  version = "0.51.3";
=======
  version = "0.48.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ijcYSuB91I9lD4qx6ohVFDQgTE0+FTQ5Hr1heNwKyUo=";
  };

  vendorHash = "sha256-DFQ59E24LR5/qodtge0EsqajvrjPN0otpxGB8JQ0ERw=";
=======
    sha256 = "sha256-e9Qof+HxSJHzAUbLb+w5oWPTOslTPxnC8BVAmtMQGlE=";
  };

  vendorHash = "sha256-DhzirX+AGe8dE62M0hiE5SlWK8HqhNN0MMk9i2Ntrs8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
