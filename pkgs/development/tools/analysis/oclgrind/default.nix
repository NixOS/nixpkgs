{ lib, stdenv, fetchFromGitHub, cmake, llvmPackages, readline, python2 }:

stdenv.mkDerivation rec {
  pname = "oclgrind";
  version = "21.10";

  src = fetchFromGitHub {
    owner = "jrprice";
    repo = "oclgrind";
    rev = "v${version}";
    sha256 = "sha256-DGCF7X2rPV1w9guxg2bMylRirXQgez24sG7Unlct3ow=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.llvm llvmPackages.clang-unwrapped readline python2 ];

  cmakeFlags = [
    "-DCLANG_ROOT=${llvmPackages.clang-unwrapped}"
  ];

  meta = with lib; {
    description = "An OpenCL device simulator and debugger";
    homepage = "https://github.com/jrprice/oclgrind";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ athas ];
  };
}
