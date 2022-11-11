{ lib, appleDerivation, xcbuildHook, zlib, bzip2, xz, ncurses, libutil, Libinfo }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ zlib bzip2 xz ncurses libutil Libinfo ];

  # some commands not working:
  # mtree: _simple.h not found
  # ipcs: sys/ipcs.h not found
  # so remove their targets from the project
  patchPhase = ''
    substituteInPlace file_cmds.xcodeproj/project.pbxproj \
      --replace "FC8A8CAA14B655FD001B97AD /* PBXTargetDependency */," "" \
      --replace "FC8A8C9C14B655FD001B97AD /* PBXTargetDependency */," "" \
      --replace "productName = file_cmds;" "" \
      --replace '/usr/lib/libcurses.dylib' 'libncurses.dylib'
    sed -i -re "s/name = ([a-zA-Z]+);/name = \1; productName = \1;/" file_cmds.xcodeproj/project.pbxproj
  '';

  # Workaround build failure on -fno-common toolchains:
  #   duplicate symbol '_chdname' in: ar_io.o tty_subs.o
  NIX_CFLAGS_COMPILE = "-fcommon";

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    for f in Products/Release/*; do
      if [ -f $f ]; then
        install -D $f $out/bin/$(basename $f)
      fi
    done

    for n in 1; do
      mkdir -p $out/share/man/man$n
      install */*.$n $out/share/man/man$n
    done
  '';

  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
