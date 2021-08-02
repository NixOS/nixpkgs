{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "headscale";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    rev = "v${version}";
    sha256 = "sha256-cjaA62YRfZSbXwbW1pz51hc/opCLsN26GxWnBcVTvyE=";
  };

  vendorSha256 = "sha256-3cGvp9hnajNJtvDn4K6fkCzLYrEFXQk9ZhQ4n+WnQEo=";

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
