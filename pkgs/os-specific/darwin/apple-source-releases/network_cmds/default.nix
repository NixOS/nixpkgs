{ stdenv, appleDerivation, xcbuild, openssl, Librpcsvc, xnu, libpcap, developer_cmds }:

appleDerivation rec {
  buildInputs = [ xcbuild openssl xnu Librpcsvc libpcap developer_cmds ];

  NIX_CFLAGS_COMPILE = " -I./unbound -I${xnu}/Library/Frameworks/System.framework/Headers/";

  # "spray" requires some files that aren't compiling correctly in xcbuild.
  # "rtadvd" seems to fail with some missing constants.
  # We disable spray and rtadvd here for now.
  patchPhase = ''
    substituteInPlace network_cmds.xcodeproj/project.pbxproj \
      --replace "7294F0EA0EE8BAC80052EC88 /* PBXTargetDependency */," "" \
      --replace "7216D34D0EE89FEC00AE70E4 /* PBXTargetDependency */," ""
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    mkdir -p $out/bin/
    install network_cmds-*/Build/Products/Release/* $out/bin/

    for n in 1 5; do
      mkdir -p $out/share/man/man$n
      install */*.$n $out/share/man/man$n
    done

    # TODO: patch files to load from $out/ instead of /usr/

    # mkdir -p $out/etc/
    # install rtadvd.tproj/rtadvd.conf ip6addrctl.tproj/ip6addrctl.conf $out/etc/

    # mkdir -p $out/local/OpenSourceVersions/
    # install network_cmds.plist $out/local/OpenSourceVersions/

    # mkdir -p $out/System/Library/LaunchDaemons
    # install kdumpd.tproj/com.apple.kdumpd.plist $out/System/Library/LaunchDaemons
 '';

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
