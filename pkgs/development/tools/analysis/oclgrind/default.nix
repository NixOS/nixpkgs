{ stdenv, fetchFromGitHub, cmake, llvmPackages, readline, python }:

stdenv.mkDerivation rec {
  pname = "oclgrind";
  version = "19.10";

  src = fetchFromGitHub {
    owner = "jrprice";
    repo = "oclgrind";
    rev = "v${version}";
    sha256 = "12v5z5x3ls26p3y3yc4mqmh12cazc0nlrwvmfbn6cyg4af9dp0zn";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.llvm llvmPackages.clang-unwrapped readline python ];

  cmakeFlags = [
    "-DCLANG_ROOT=${llvmPackages.clang-unwrapped}"
  ];

  meta = with stdenv.lib; {
    description = "An OpenCL device simulator and debugger";
    homepage = https://github.com/jrprice/oclgrind;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ athas ];
  };
}
