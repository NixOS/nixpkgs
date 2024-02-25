{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwx";
  version = "2.0.20";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+of0eYBwdGC9vb0DDqxMIuhXNTCRRv9iGOIVJGobMxc=";
  };

  vendorHash = "sha256-HHq4B0MYP2gUtV9ywrXVmWN7OpV6NVb49rVMFblOgPc=";

  sourceRoot = "${src.name}/cmd/jwx";

  meta = with lib; {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    homepage = "https://github.com/lestrrat-go/jwx";
    license = licenses.mit;
    maintainers = with maintainers; [ arianvp flokli ];
  };
}
