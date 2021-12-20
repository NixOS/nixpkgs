{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ytarchive";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "v${version}";
    sha256 = "sha256-7D92xKxU2WBMDJSY5uFKDbLHWlyT761xuZDiBJ1GxE4=";
  };

  vendorSha256 = "sha256-r9fDFSCDItQ7YSj9aTY1LXRrFE9T3XD0X36ywCfu0R8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/Kethsar/ytarchive";
    description = "Garbage Youtube livestream downloader";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
