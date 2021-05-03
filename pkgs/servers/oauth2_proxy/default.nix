{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "6.0.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "0mbjg0d0w173xpq69frjdvgyx5k74pkrfx3phc3lq8snvhnf1c2n";
    rev = "v${version}";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-21291.patch";
      url = "https://github.com/oauth2-proxy/oauth2-proxy/commit/780ae4f3c99b579cb2ea9845121caebb6192f725.patch";
      sha256 = "066cr6ml69pinw3j9rspjy2h3dvqmf4bvmdxvalb1ws3z0xkn4ag";
    })
  ];

  vendorSha256 = "1hrk3h729kcc77fq44kiywmyzk5a78v7bm5d2yl76lfxxdcdric7";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  buildFlagsArray = ("-ldflags=-X main.VERSION=${version}");

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    maintainers = with maintainers; [ yorickvp knl ];
  };
}
