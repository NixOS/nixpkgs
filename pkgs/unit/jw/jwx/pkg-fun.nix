{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwx";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eoXSSXh9NxWLgogrE2hDjsPxqeUmH54TnYXwhm7kpz4=";
  };

  vendorSha256 = "sha256-fbNnSjUOHnm/zxEGdhHQEKHgYp+nW1rgvMGJBm4b9IM=";

  sourceRoot = "source/cmd/jwx";

  meta = with lib; {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    homepage = "https://github.com/lestrrat-go/jwx";
    license = licenses.mit;
    maintainers = with maintainers; [ arianvp flokli ];
  };
}
