{ stdenv, cmake, llvmPackages, irony }:

stdenv.mkDerivation {
  pname = "irony-server";
  inherit (irony) src version;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.libclang llvmPackages.llvm ];

  dontUseCmakeBuildDir = true;

  cmakeDir = "server";

  cmakeFlags = [
    "-DCMAKE_PREFIX_PATH=${llvmPackages.clang-unwrapped}"
  ];

  meta = with stdenv.lib; {
    description = "The server part of irony.";
    homepage = "https://melpa.org/#/irony";
    maintainers = [ maintainers.deepfire ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
