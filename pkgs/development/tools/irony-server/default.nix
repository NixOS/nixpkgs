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

<<<<<<< HEAD
  meta = {
    description = "Server part of irony";
    mainProgram = "irony-server";
    homepage = "https://melpa.org/#/irony";
    maintainers = [ lib.maintainers.deepfire ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
=======
  meta = with lib; {
    description = "Server part of irony";
    mainProgram = "irony-server";
    homepage = "https://melpa.org/#/irony";
    maintainers = [ maintainers.deepfire ];
    platforms = platforms.unix;
    license = licenses.free;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
