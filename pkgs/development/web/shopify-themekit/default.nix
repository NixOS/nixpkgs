{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "shopify-themekit";
  version = "1.0.3";

  goPackagePath = "github.com/Shopify/themekit/";

  goDeps = ./shopify-themekit_deps.nix;

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "themekit";
    rev = "v${version}";
    sha256 = "1780h33mf2h2lv6mr4xx3shfvsabr7w138yb59vvdgvjng9wjkg0";
  };

  meta = with lib; {
    description = "A command line tool for shopify themes";
    homepage = "https://shopify.github.io/themekit/";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
  };
}
