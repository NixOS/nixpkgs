{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "headscale";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    rev = "v${version}";
    sha256 = "sha256-/mpSIS3UajxFTQm+/Ko6e0hZ8kbPWSNNctaYKaGl8Gs=";
  };

  vendorSha256 = "sha256-ususDOF/LznhK4EInHE7J/ItMjziGfP9Gn8/Q5wd78g=";

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
