{ stdenv, appleDerivation, xcbuildHook
, openssl_1_0_2, Librpcsvc, xnu, libpcap, developer_cmds }:

appleDerivation rec {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ openssl_1_0_2 xnu Librpcsvc libpcap developer_cmds ];

  NIX_CFLAGS_COMPILE = " -I./unbound -I${xnu}/Library/Frameworks/System.framework/Headers/";

  # "spray" requires some files that aren't compiling correctly in xcbuild.
  # "rtadvd" seems to fail with some missing constants.
  # "traceroute6" and "ping6" require ipsec which doesn't build correctly
  patchPhase = ''
    substituteInPlace network_cmds.xcodeproj/project.pbxproj \
      --replace "7294F0EA0EE8BAC80052EC88 /* PBXTargetDependency */," "" \
      --replace "7216D34D0EE89FEC00AE70E4 /* PBXTargetDependency */," "" \
      --replace "72CD1D9C0EE8C47C005F825D /* PBXTargetDependency */," "" \
      --replace "7216D2C20EE89ADF00AE70E4 /* PBXTargetDependency */," ""
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    for f in Products/Release/*; do
      if [ -f $f ]; then
        install -D $f $out/bin/$(basename $f)
      fi
    done

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
