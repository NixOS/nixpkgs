{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "headscale";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    rev = "v${version}";
    sha256 = "sha256-AclIH2Gd8U/Hfy24KOFic/np4qAWELlIMfsPCSkdjog=";
  };

  vendorSha256 = "sha256-UIBH6Pf2mmXBsdFW0RRvedLQhonNsrl4j2fxxRtum4M=";

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
