{ fetchFromGitHub, buildGoModule, lib, stdenv }:
buildGoModule rec {
  pname = "ory-hydra";
  version = "2.0.3";
  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    rev = "v${version}";
    sha256 = "sha256-TFJZGLqzJHFqabZaVh1219xGzNuJ1CRiZADtvWo8964=";
  };
  vendorSha256 = "sha256-xGe50VHnjyCJ3XGJ95S+Axngcp/Jmkn/V65iDYVmE+c=";
  subPackages = [ "." ];
  meta = with lib; {
    maintainers = with maintainers; [ arianvp ];
    homepage = "https://www.ory.sh/hydra/";
    license = licenses.asl20;
    description = "OpenID Certified™ OpenID Connect and OAuth Provider written in Go - cloud native, security-first, open source API security for your infrastructure. SDKs for any language. Works with Hardware Security Modules. Compatible with MITREid.";
  };
}
