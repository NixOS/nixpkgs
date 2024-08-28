{ lib, appleDerivation, xcbuildHook }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];

  # These PBXcp calls should be patched in xcbuild to allow them to
  # automatically be prefixed.
  patchPhase = ''
    substituteInPlace basic_cmds.xcodeproj/project.pbxproj \
      --replace "dstPath = /usr/share/man/man1;" "dstPath = $out/share/man/man1;" \
      --replace "dstPath = /usr/share/man/man5;" "dstPath = $out/share/man/man5;"
  '';

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
