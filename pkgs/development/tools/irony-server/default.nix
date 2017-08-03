{ stdenv, fetchgit, cmake, llvmPackages, irony }:

stdenv.mkDerivation rec {
  name = "irony-server-${version}";
  inherit (irony) version;

  buildInputs = [ cmake llvmPackages.clang ];

  dontUseCmakeBuildDir = true;

  cmakeDir = "server";

  cmakeFlags = [
    ''-DCMAKE_PREFIX_PATH=${llvmPackages.clang.cc}''
  ];

  src = irony.src;

  meta = {
    description = "The server part of irony.";
    homepage = "https://melpa.org/#/irony";
    maintainers = [ stdenv.lib.maintainers.deepfire ];
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.free;
  };
}
