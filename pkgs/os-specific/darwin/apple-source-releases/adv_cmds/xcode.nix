{ stdenv, appleDerivation, fetchurl, xcbuild, libcxx }:

appleDerivation {

  # pkill requires special private headers that are unavailable in
  # NixPkgs. These ones are needed:
  #  - xpc/xpxc.h
  #  - os/base_private.h
  #  - _simple.h
  # We disable it here for now. TODO: build pkill inside adv_cmds

  # We also disable locale here because of some issues with a missing
  # "lstdc++".
  patchPhase = ''
    substituteInPlace adv_cmds.xcodeproj/project.pbxproj \
      --replace "FD201DC214369B4200906237 /* pkill.c in Sources */," "" \
      --replace "FDF278D60FC6204E00D7A3C6 /* locale.cc in Sources */," ""
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    mkdir -p $out/bin/
    install adv_cmds-*/Build/Products/Release/* $out/bin/

    for n in 1 8; do
      mkdir -p $out/share/man/man$n
      install */*.$n $out/share/man/man$n
    done

    mkdir -p $out/System/Library/LaunchDaemons
    install fingerd/finger.plist $out/System/Library/LaunchDaemons

    # from variant_links.sh
    # ln -s $out/bin/pkill $out/bin/pgrep
    # ln -s $out/share/man/man1/pkill.1 $out/share/man/man1/pgrep.1
  '';

  buildInputs = [ xcbuild libcxx ];

  # temporary fix for iostream issue
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
