{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "codesearch";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "codesearch";
    rev = "v${version}";
    sha256 = "sha256-i03w8PZ31j5EutUZaamZsHz+z4qgX4prePbj5DLA78s=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Fast, indexed regexp search over large file trees";
    homepage = "https://github.com/google/codesearch";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
