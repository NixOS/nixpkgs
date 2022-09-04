{ fetchFromGitHub
, lib
}:

{
  version = "0.19.0";
  srcSha256 = "sha256:0s5ji1iywymzxlv89y3ivl5vngkifhbpidpwxdrh969l3c5r4klf";
  vendorSha256 = "sha256:1p78nb7bryvs7p5iq6ihylflyjia60x4hd9c62ffwz37dwqlbi33";
  yarnSha256 = "sha256:1n6swanrds9hbd4yyfjzpnfhsb8fzj1pwvvcg3w7b1cgnihclrmv";

  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    sha256 = srcSha256;
  };

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Authenticating reverse proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
