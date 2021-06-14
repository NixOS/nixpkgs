{ lib, stdenv, cmake, llvmPackages, irony }:

stdenv.mkDerivation {
  pname = "irony-server";
  inherit (irony) src version;

  nativeBuildInputs = [ cmake llvmPackages.llvm.dev ];
  buildInputs = [ llvmPackages.libclang llvmPackages.llvm ];

  dontUseCmakeBuildDir = true;

  cmakeDir = "server";

  meta = with lib; {
    description = "The server part of irony";
    homepage = "https://melpa.org/#/irony";
    maintainers = [ maintainers.deepfire ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
