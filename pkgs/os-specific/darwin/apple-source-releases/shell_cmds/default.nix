{ stdenv, appleDerivation, xcbuild }:

appleDerivation rec {
  buildInputs = [ xcbuild ];

  patchPhase = ''
    # NOTE: these hashes must be recalculated for each version change

    # disables:
    # - su ('security/pam_appl.h' file not found)
    # - find (Undefined symbol '_get_date')
    # - w (Undefined symbol '_res_9_init')
    substituteInPlace shell_cmds.xcodeproj/project.pbxproj \
      --replace "FCBA168714A146D000AA698B /* PBXTargetDependency */," "" \
      --replace "FCBA165914A146D000AA698B /* PBXTargetDependency */," "" \
      --replace "FCBA169514A146D000AA698B /* PBXTargetDependency */," ""

    # disable w, test install
    # get rid of permission stuff
    substituteInPlace xcodescripts/install-files.sh \
      --replace 'ln -f "$BINDIR/w" "$BINDIR/uptime"' "" \
      --replace 'ln -f "$DSTROOT/bin/test" "$DSTROOT/bin/["' "" \
      --replace "-o root -g wheel -m 0755" "" \
      --replace "-o root -g wheel -m 0644" ""
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    mkdir -p $out/usr/bin
    install shell_cmds-*/Build/Products/Release/* $out/usr/bin

    export DSTROOT=$out
    export SRCROOT=$PWD
    . xcodescripts/install-files.sh

    mv $out/usr/* $out
    mv $out/private/etc $out
    rmdir $out/usr $out/private
  '';

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
