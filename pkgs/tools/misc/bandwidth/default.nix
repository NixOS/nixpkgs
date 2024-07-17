{
  lib,
  stdenv,
  fetchurl,
  nasm,
}:

let
  inherit (stdenv.hostPlatform.parsed.cpu) bits;
  arch = "bandwidth${toString bits}";
in
stdenv.mkDerivation rec {
  pname = "bandwidth";
  version = "1.11.2d";

  src = fetchurl {
    url = "https://zsmith.co/archives/${pname}-${version}.tar.gz";
    hash = "sha256-7IrNiCXKf1vyRGl73Ccu3aYMqPVc4PpEr6lnSqIa4Q8=";
  };

  postPatch = ''
    sed -i 's,ar ,$(AR) ,g' OOC/Makefile
    # Remove unnecessary -m32 for 32-bit targets
    sed -i 's,-m32,,g' OOC/Makefile
    # Replace arm64 with aarch64
    sed -i 's#,arm64#,aarch64#g' Makefile
    # Fix wrong comment character
    sed -i 's,# 32,; 32,g' routines-x86-32bit.asm
    # Fix missing symbol exports for macOS clang
    echo global _VectorToVector128 >> routines-x86-64bit.asm
    echo global _VectorToVector256 >> routines-x86-64bit.asm
    # Fix unexpected token on macOS
    sed -i '/.section .note.GNU-stack/d' *-64bit.asm
    sed -i '/.section code/d' *-arm-64bit.asm
    sed -i 's#-Wl,-z,noexecstack##g' Makefile-arm64
  '';

  nativeBuildInputs = [ nasm ];

  buildFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
    "CC=${stdenv.cc.targetPrefix}cc"
    "ARM_AS=${stdenv.cc.targetPrefix}as"
    "ARM_CC=$(CC)"
    "UNAMEPROC=${stdenv.hostPlatform.parsed.cpu.name}"
    "UNAMEMACHINE=${stdenv.hostPlatform.parsed.cpu.name}"
    arch
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${arch} $out/bin/bandwidth
  '';

  meta = with lib; {
    homepage = "https://zsmith.co/bandwidth.html";
    description = "Artificial benchmark for identifying weaknesses in the memory subsystem";
    license = licenses.gpl2Plus;
    platforms = platforms.x86 ++ platforms.arm ++ platforms.aarch64;
    maintainers = with maintainers; [ r-burns ];
    mainProgram = "bandwidth";
  };
}
