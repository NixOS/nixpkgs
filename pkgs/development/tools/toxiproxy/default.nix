{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "toxiproxy-${version}";
  version = "2.1.3";
  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "toxiproxy";
    rev = "v${version}";
    sha256 = "1a7yry846iwi9cs9xam2vjbw73fjy45agjrwk214k0n1ziaawz2f";
  };

  goPackagePath = "github.com/Shopify/toxiproxy";
  subPackages = ["cmd" "cli"];
  buildFlagsArray = "-ldflags=-X github.com/Shopify/toxiproxy.Version=v${version}";

  postInstall = ''
    mv $bin/bin/cli $bin/bin/toxiproxy-cli
    mv $bin/bin/cmd $bin/bin/toxiproxy-cmd
  '';

  meta = {
    description = "Proxy for for simulating network conditions.";
    maintainers = with lib.maintainers; [ avnik ];
  };
}
