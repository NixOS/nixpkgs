{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ytarchive";
  version = "unstable-2021-12-29";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "2d87608c0b159da876538380b3e613bce2797599";
    sha256 = "sha256-/cnyKcbgd6I0Ad5aZQd2pCbnU6HZYfuPHK2Ty7yYgHs=";
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
