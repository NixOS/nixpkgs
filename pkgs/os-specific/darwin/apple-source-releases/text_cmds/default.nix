{ lib, appleDerivation, xcbuildHook, ncurses, bzip2, zlib, xz }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ ncurses bzip2 zlib xz ];

  # patches to use ncursees
  # disables md5
  patchPhase = ''
    substituteInPlace text_cmds.xcodeproj/project.pbxproj \
          --replace 'FC6C98FB149A94EB00DDCC47 /* libcurses.dylib */ = {isa = PBXFileReference; lastKnownFileType = "compiled.mach-o.dylib"; name = libcurses.dylib; path = /usr/lib/libcurses.dylib; sourceTree = "<absolute>"; };' 'FC6C98FB149A94EB00DDCC47 /* libncurses.dylib */ = {isa = PBXFileReference; lastKnownFileType = "compiled.mach-o.dylib"; name = libncurses.dylib; path = /usr/lib/libncurses.dylib; sourceTree = "<absolute>"; };' \
      --replace 'FC7A7EB5149875E00086576A /* PBXTargetDependency */,' ""
  '';

  installPhase = ''
    for f in Products/Release/*; do
      if [ -f $f ]; then
        install -D $f $out/bin/$(basename $f)
      fi
    done
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    # hardeningDisable doesn't cut it
    "-Wno-error=format-security"
    # Required to build with clang 16
    "-Wno-error=deprecated-non-prototype"
  ];

  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
