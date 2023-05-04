{ lib, fetchFromGitHub, fetchpatch, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "refs/tags/v${version}";
    hash = "sha256-pc9mtVR/PBhM5l1PnDkm+y+McxbrfAmQzxmLi761VF4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/crystal-ameba/ameba/commit/c7f2cba409787a1928fbb54494b4645ec11005cc.patch";
      hash = "sha256-tYEPke6omMdCGG2llJGXDZ3jTO4YAqpknzTPi2576UI=";
    })
  ];

  format = "make";

  meta = with lib; {
    description = "A static code analysis tool for Crystal";
    homepage = "https://crystal-ameba.github.io";
    changelog = "https://github.com/crystal-ameba/ameba/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}
