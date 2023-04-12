{ lib, appleDerivation, xcbuildHook, Libc, stdenv, macosPackages_11_0_1, xnu
, fetchurl, libutil }:

let
  xnu-src = if stdenv.isAarch64 then macosPackages_11_0_1.xnu.src else xnu.src;
  arch = if stdenv.isAarch64 then "arm" else "i386";
in appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ libutil ];

  env.NIX_CFLAGS_COMPILE = "-I.";
  NIX_LDFLAGS = "-lutil";
  patchPhase = ''
    # ugly hacks for missing headers
    # most are bsd related - probably should make this a drv
    unpackFile ${Libc.src}
    unpackFile ${xnu-src}
    mkdir System sys machine ${arch}
    cp xnu-*/bsd/sys/disklabel.h sys
    cp xnu-*/bsd/machine/disklabel.h machine
    cp xnu-*/bsd/${arch}/disklabel.h ${arch}
    cp -r xnu-*/bsd/sys System
    cp -r Libc-*/uuid System
    substituteInPlace diskdev_cmds.xcodeproj/project.pbxproj \
      --replace 'DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";' ""
  '';
  installPhase = ''
    install -D Products/Release/libdisk.a $out/lib/libdisk.a
    rm Products/Release/libdisk.a
    for f in Products/Release/*; do
      if [ -f $f ]; then
        install -D $f $out/bin/$(basename $f)
      fi
    done
  '';

  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
