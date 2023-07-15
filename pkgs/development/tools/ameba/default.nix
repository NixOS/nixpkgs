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
    (fetchpatch {
      # Fixes: Error: type must be Ameba::Severity, not (Ameba::Severity | Nil)
      name = "crystal-1.9-compatibility-1.patch";
      url = "https://github.com/crystal-ameba/ameba/commit/d0d8b18c8365fd956d1e65ae6051e83a5e129f18.patch";
      hash = "sha256-NmA3OoS5aOW+28TV/D/LUKEEu3lzHlcpolggHBB/wHE=";
    })
    (fetchpatch {
      # Ignore some failing lints on the Ameba codebase run during the check phase.
      name = "crystal-1.9-compatibility-2.patch";
      url = "https://github.com/crystal-ameba/ameba/commit/c9d25f3409e6a127bbd7188267810657a2c2924e.patch";
      hash = "sha256-JMKiO0izSXfgw7uM9XXQ0r/ntOwRnjzYeVHqVLAvLXo=";
    })
    (fetchpatch {
      # Fixes test failures due to Crystal compiler error messages changing.
      name = "crystal-1.9-compatibility-3.patch";
      url = "https://github.com/crystal-ameba/ameba/commit/db59b23f9bfcf53dbe53d2918bd9c3d79ac24bb6.patch";
      hash = "sha256-MKbEm9CR4+VzioCjcOFuFF0xnc1Ty0Ij4d3FcvQO6hY=";
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
