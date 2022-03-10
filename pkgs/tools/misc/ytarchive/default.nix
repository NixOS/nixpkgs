{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ytarchive";
  version = "unstable-2022-02-16";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "66a1ca003de7302c99bda943500257d5fd374199";
    sha256 = "sha256-6eLNyInqXB+LWbZ18DvXbTdpRpiCDMGwJaiyQfZZ4xM=";
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
