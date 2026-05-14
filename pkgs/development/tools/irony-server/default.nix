{
  lib,
  stdenv,
  cmake,
  llvmPackages,
  llvm,
  irony,
}:

stdenv.mkDerivation {
  pname = "irony-server";
  inherit (irony) src version;

  nativeBuildInputs = [
    cmake
    llvm
  ];
  buildInputs = [ llvmPackages.libclang ];

  dontUseCmakeBuildDir = true;

  cmakeDir = "server";

  meta = {
    description = "Server part of irony";
    mainProgram = "irony-server";
    homepage = "https://melpa.org/#/irony";
    maintainers = [ lib.maintainers.deepfire ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
  };
}
