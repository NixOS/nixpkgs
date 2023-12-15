{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwx";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5IO9CoW9KBpgVxpnH1HEC5O4MJjCPERsmiV/cHcnmAc=";
  };

  vendorHash = "sha256-o3EHPIXGLz/io0d8jhl9cxzctP3CeOjEDMQl1SY9lXg=";

  sourceRoot = "${src.name}/cmd/jwx";

  meta = with lib; {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    homepage = "https://github.com/lestrrat-go/jwx";
    license = licenses.mit;
    maintainers = with maintainers; [ arianvp flokli ];
  };
}
