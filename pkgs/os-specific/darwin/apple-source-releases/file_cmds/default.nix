{ stdenv, appleDerivation, xcbuild, zlib, bzip2, lzma, ncurses, libutil-new }:

appleDerivation rec {
  buildInputs = [ xcbuild zlib bzip2 lzma ncurses libutil-new ];

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

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    mkdir -p $out/bin/
    install file_cmds-*/Build/Products/Release/* $out/bin

    for n in 1; do
      mkdir -p $out/share/man/man$n
      install */*.$n $out/share/man/man$n
    done
  '';

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
