{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shopify-themekit";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "themekit";
    rev = "v${version}";
    sha256 = "sha256-7uUKyaLzeiioW0TsEu82lJU0DoM1suwVcmacY1X0SEM=";
  };

  vendorSha256 = "sha256-8QpkYj0fQb4plzvk6yCrZho8rq9VBiLft/EO3cczciI=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    # Keep `theme` only
    rm -f $out/bin/{cmd,tkrelease}
  '';

  meta = with lib; {
    description = "A command line tool for shopify themes";
    homepage = "https://shopify.github.io/themekit/";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
  };
}
