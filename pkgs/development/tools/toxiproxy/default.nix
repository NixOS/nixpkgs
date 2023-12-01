{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "toxiproxy";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "toxiproxy";
    rev = "v${version}";
    sha256 = "sha256-SL3YHsNeFw8K8lPrzJXAoTkHxS+1sTREfzjawBxdnf0=";
  };

  vendorHash = "sha256-CmENxPAdjz0BAyvhLKIaJjSbK/mvRzHGCQOfGIiA3yI=";

  excludedPackages = [ "test/e2e" ];

  ldflags = [ "-s" "-w" "-X github.com/Shopify/toxiproxy/v2.Version=${version}" ];

  # Fixes tests on Darwin
  __darwinAllowLocalNetworking = true;

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
