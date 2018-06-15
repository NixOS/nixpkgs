{ stdenv, appleDerivation, fetchurl, xcbuild }:

appleDerivation rec {
  buildInputs = [ xcbuild ];

  # These PBXcp calls should be patched in xcbuild to allow them to
  # automatically be prefixed.
  patchPhase = ''
    substituteInPlace basic_cmds.xcodeproj/project.pbxproj \
      --replace "dstPath = /usr/share/man/man1;" "dstPath = $out/share/man/man1;" \
      --replace "dstPath = /usr/share/man/man5;" "dstPath = $out/share/man/man5;"
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    mkdir -p $out/bin/
    install Products/Release/* $out/bin/

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
