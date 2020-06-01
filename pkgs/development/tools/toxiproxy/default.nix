{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "toxiproxy";
  version = "2.1.4";
  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "toxiproxy";
    rev = "v${version}";
    sha256 = "07yhsvscdv1qjfc2fyyh9qsrrdwrrw04wadk5gaq4qddcway7vig";
  };

  goPackagePath = "github.com/Shopify/toxiproxy";
  subPackages = ["cmd" "cli"];
  buildFlagsArray = "-ldflags=-X github.com/Shopify/toxiproxy.Version=v${version}";

  postInstall = ''
    mv $out/bin/cli $out/bin/toxiproxy-cli
    mv $out/bin/cmd $out/bin/toxiproxy-cmd
  '';

  meta = {
    description = "Proxy for for simulating network conditions.";
    maintainers = with lib.maintainers; [ avnik ];
    license = lib.licenses.mit;
  };
}
