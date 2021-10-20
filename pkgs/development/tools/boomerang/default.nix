{ mkDerivation, lib, fetchFromGitHub, fetchpatch, cmake, qtbase, capstone, bison, flex }:

mkDerivation rec {
  pname = "boomerang";
  version = "0.5.2";
  # NOTE: When bumping version beyond 0.5.2, you likely need to remove
  #       the cstdint.patch below. The patch does a fix that has already
  #       been done upstream but is not yet part of a release

  src = fetchFromGitHub {
    owner = "BoomerangDecompiler";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xncdp0z8ry4lkzmvbj5d7hlzikivghpwicgywlv47spgh8ny0ix";
  };

  nativeBuildInputs = [ cmake bison flex ];
  buildInputs = [ qtbase capstone ];
  patches = [
    (fetchpatch {
      name = "include-missing-cstdint.patch";
      url = "https://github.com/BoomerangDecompiler/boomerang/commit/3342b0eac6b7617d9913226c06c1470820593e74.patch";
      sha256 = "sha256-941IydcV3mqj7AWvXTM6GePW5VgawEcL0wrBCXqeWvc=";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/BoomerangDecompiler/boomerang";
    license = licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
    maintainers = with maintainers; [ dtzWill ];
  };
}
