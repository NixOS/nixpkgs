{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, capstone, bison, flex }:

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
  patches = [ ./cstdint.patch ];

  meta = with lib; {
    homepage = "https://github.com/BoomerangDecompiler/boomerang";
    license = licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
    maintainers = with maintainers; [ dtzWill ];
  };
}
