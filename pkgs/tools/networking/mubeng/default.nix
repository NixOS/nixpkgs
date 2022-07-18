{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qEIPu4miZpWL19N36DsKMbckXbHDTTZjp2ccZrV3LFc=";
  };

  vendorSha256 = "sha256-sAcDyGNOSm+BnsYyrR2x1vkGo6ZEykhkF7L9lzPrD+o=";

  ldflags = [ "-s" "-w" "-X ktbs.dev/mubeng/common.Version=${version}" ];

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
