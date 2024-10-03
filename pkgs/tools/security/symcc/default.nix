{ stdenv
, fetchFromGitHub
, cmake
, ninja
, llvm_9
, clang_9
, z3
}:

stdenv.mkDerivation rec {
  pname = "symcc";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "eurecom-s3";
    repo = pname;
    rev = "v${version}";
    sha256 = "152b8p861rhdixh63qxk01xb1fpc500mi3sxrw0j5lsq974wbi6a";
  };

  nativeBuildInputs = [
    cmake ninja llvm_9 clang_9
  ];

  buildInputs = [
    z3
  ];

  meta = with stdenv.lib; {
    description = "efficient compiler-based symbolic execution";
    homepage = "http://www.s3.eurecom.fr/tools/symbolic_execution/symcc.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dump_stack ];
    platforms = platforms.linux;
  };
}
