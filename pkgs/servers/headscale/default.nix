{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "headscale";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    rev = "v${version}";
    sha256 = "0iij4hdbdplai5c8kvcwiw11idrk04xbpwb3njdhqcg6pdyx3216";
  };

  vendorSha256 = "sha256-8MCSN8wn2Y9ejHAIEwTdIXGITaa+FqX7WUMJEr0RcIk=";

  # Ldflags are same as build target in the project's Makefile
  # https://github.com/juanfont/headscale/blob/main/Makefile
  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  meta = with lib; {
    description = "An implementation of the Tailscale coordination server";
    homepage = "https://github.com/juanfont/headscale";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nkje ];
  };
}
