{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "toxiproxy";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "toxiproxy";
    rev = "v${version}";
    sha256 = "sha256-vFf1yLpAa+yO1PCE+pLTnvvtROtpVxlEgACDNNUWBEM=";
  };

  vendorSha256 = "sha256-mrRMyIU6zeyAT/fXbBmtMlZzpyeB45FQmYJ4FDwTRTo=";

  excludedPackages = [ "test/e2e" ];

  ldflags = [ "-s" "-w" "-X github.com/Shopify/toxiproxy/v2.Version=${version}" ];

  checkFlags = [ "-short" ];

  postInstall = ''
    mv $out/bin/cli $out/bin/toxiproxy-cli
    mv $out/bin/server $out/bin/toxiproxy-server
  '';

  meta = {
    description = "Proxy for for simulating network conditions";
    homepage = "https://github.com/Shopify/toxiproxy";
    maintainers = with lib.maintainers; [ avnik ];
    license = lib.licenses.mit;
  };
}
