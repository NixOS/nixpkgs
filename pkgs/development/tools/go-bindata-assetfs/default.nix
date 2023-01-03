{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-bindata-assetfs";
  version = "unstable-2022-04-12";

  src = fetchFromGitHub {
    owner = "elazarl";
    repo = "go-bindata-assetfs";
    rev = "de3be3ce9537d87338bf26ac211d02d4fa568bb8";
    hash = "sha256-yQgIaTl06nmIu8BfmQzrvEnlPQ2GQ/2nnvTmYXCL1oI=";
  };

  vendorHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Serve embedded files from jteeuwen/go-bindata";
    license = licenses.bsd2;
    maintainers = with maintainers; [ avnik ];
  };
}
