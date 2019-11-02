{ stdenv, fetchFromGitHub, cmake, llvmPackages, readline, python }:

stdenv.mkDerivation rec {
  pname = "oclgrind";
  version = "18.3"; # see comment in all-packages.nix

  src = fetchFromGitHub {
    owner = "jrprice";
    repo = "oclgrind";
    rev = "v${version}";
    sha256 = "0s42z3dg684a0gk8qyx2h08cbh95zkrdaaj9y71rrc5bjsg8197x";
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
