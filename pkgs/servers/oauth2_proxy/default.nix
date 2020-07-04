{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "5.1.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pusher";
    sha256 = "190k1v2c1f6vp9waqs01rlzm0jc3vrmsq1w1n0c2q2nfqx76y2wz";
    rev = "v${version}";
  };

  vendorSha256 = "01lf7xbhgn5l42ahym12vr1w00zx1qzy6sgwgcbvvxp48k0b271d";

  doCheck = true;

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  buildFlagsArray = ("-ldflags=-X main.VERSION=${version}");

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    maintainers = with maintainers; [ yorickvp knl ];
  };
}
