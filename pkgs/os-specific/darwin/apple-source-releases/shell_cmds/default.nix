{ lib, appleDerivation, xcbuildHook, launchd }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook launchd ];

  patchPhase = ''
    # NOTE: these hashes must be recalculated for each version change

    # disables:
    # - su ('security/pam_appl.h' file not found)
    # - find (Undefined symbol '_get_date')
    # - w (Undefined symbol '_res_9_init')
    # - expr
    substituteInPlace shell_cmds.xcodeproj/project.pbxproj \
      --replace-fail "FCBA168714A146D000AA698B /* PBXTargetDependency */," "" \
      --replace-fail "FCBA165914A146D000AA698B /* PBXTargetDependency */," "" \
      --replace-fail "FCBA169514A146D000AA698B /* PBXTargetDependency */," "" \
      --replace-fail "FCBA165514A146D000AA698B /* PBXTargetDependency */," ""

    # disable w, test install
    # get rid of permission stuff
    substituteInPlace xcodescripts/install-files.sh \
      --replace-fail 'ln -f "$BINDIR/w" "$BINDIR/uptime"' "" \
      --replace-fail 'ln -f "$DSTROOT/bin/test" "$DSTROOT/bin/["' "" \
      --replace-fail "-o root -g wheel -m 0755" "" \
      --replace-fail "-o root -g wheel -m 0644" ""
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    for f in Products/Release/*; do
      if [ -f $f ]; then
        install -D $f $out/usr/bin/$(basename $f)
      fi
    done

    export DSTROOT=$out
    export SRCROOT=$PWD
    . xcodescripts/install-files.sh

    mv $out/usr/* $out
    mv $out/private/etc $out
    rmdir $out/usr $out/private
  '';

  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
