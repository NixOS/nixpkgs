{ stdenv, appleDerivation, xcbuildHook
, Libc, xnu, libutil }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ libutil ];

  NIX_CFLAGS_COMPILE = "-I.";
  NIX_LDFLAGS = "-lutil";
  patchPhase = ''
    # ugly hacks for missing headers
    # most are bsd related - probably should make this a drv
    unpackFile ${Libc.src}
    unpackFile ${xnu.src}
    mkdir System sys machine i386
    cp xnu-*/bsd/sys/disklabel.h sys
    cp xnu-*/bsd/machine/disklabel.h machine
    cp xnu-*/bsd/i386/disklabel.h i386
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
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
