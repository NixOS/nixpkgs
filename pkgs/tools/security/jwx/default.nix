{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwx";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rnzRl7pvX/qBteEbgXrFCzAvtP9Izy6YAZJhy/4nXl4=";
  };

  vendorSha256 = "sha256-96Vxl84+xjRGxudBOaMX8LpRxfYqC2c+hVsipT0NLwE=";

  sourceRoot = "source/cmd/jwx";

  meta = with lib; {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    homepage = "https://github.com/lestrrat-go/jwx";
    license = licenses.mit;
    maintainers = with maintainers; [ arianvp flokli ];
  };
}
