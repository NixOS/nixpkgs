{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "oauth2_proxy";
  version = "5.1.0";

  goPackagePath = "github.com/pusher/${pname}";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pusher";
    sha256 = "190k1v2c1f6vp9waqs01rlzm0jc3vrmsq1w1n0c2q2nfqx76y2wz";
    rev = "v${version}";
  };

  goDeps = ./deps.nix;

  doCheck = true;

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  buildFlagsArray = ("-ldflags=-X main.VERSION=${version}");

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/pusher/oauth2_proxy/";
    license = licenses.mit;
    maintainers = with maintainers; [ yorickvp knl ];
  };
}
