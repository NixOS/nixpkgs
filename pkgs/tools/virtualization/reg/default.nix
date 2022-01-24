{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "reg";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "genuinetools";
    repo = "reg";
    rev = "v${version}";
    sha256 = "1jlza1czfssssi3y9zi6kr8k9msfa7vp215ibhwbz4h97av5xw5m";
  };

  vendorSha256 = null;
  doCheck = false;

  meta = with lib; {
    description = "Docker registry v2 command line client and repo listing generator with security checks";
    homepage = "https://github.com/genuinetools/reg";
    license = licenses.mit;
    maintainers = with maintainers; [ ereslibre ];
  };
}
