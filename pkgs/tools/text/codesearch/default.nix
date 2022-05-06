{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "codesearch";
  version = "1.0.0";

  goPackagePath = "github.com/google/codesearch";

  src = fetchFromGitHub {
    owner = "google";
    repo = "codesearch";
    rev = "v${version}";
    sha256 = "sha256-3kJ/JT89krbIvprWayBL4chUmT77Oa1W13UNCr4fe4k=";
  };

  meta = with lib; {
    description = "Fast, indexed regexp search over large file trees";
    homepage = "https://github.com/google/codesearch";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
