{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "shopify-themekit";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "themekit";
    rev = "v${version}";
    sha256 = "sha256-7uUKyaLzeiioW0TsEu82lJU0DoM1suwVcmacY1X0SEM=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-bKdksrkPWZ7gmxXChug3JKVR0wIPOv7NEhVre5mDaA8=";

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
