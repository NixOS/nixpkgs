{ lib, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  pname = "oauth2_proxy";
  version = "3.2.0";
  
  goPackagePath = "github.com/pusher/${pname}";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pusher";
    sha256 = "0k73ggyh12g2vzjq91i9d3bxbqfvh5k6njzza1lvkzasgp07wisg";
    rev = "v${version}";
  };

  goDeps = ./deps.nix;

  patches = [ 
    (fetchpatch {
        url = https://github.com/oauth2-proxy/oauth2-proxy/commit/a316f8a06f3c0ca2b5fc5fa18a91781b313607b2.patch;
        excludes = [ "CHANGELOG.md" ];
        sha256 = "1bnij902418hy1rh9d1g16wpxw5w6zvg52iylbs2y1zi88y7a01c";
    })
  ];

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github or other provider";
    homepage = https://github.com/pusher/oauth2_proxy/;
    license = licenses.mit;
    maintainers = [ maintainers.yorickvp ];
  };
}
