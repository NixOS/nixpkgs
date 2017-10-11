{ stdenv, appleDerivation, xcbuild }:

appleDerivation rec {
  # xcbuild fails with:
  # /nix/store/fc0rz62dh8vr648qi7hnqyik6zi5sqx8-xcbuild-wrapper/nix-support/setup-hook: line 1:  9083 Segmentation fault: 11  xcodebuild OTHER_CFLAGS="$NIX_CFLAGS_COMPILE" OTHER_CPLUSPLUSFLAGS="$NIX_CFLAGS_COMPILE" OTHER_LDFLAGS="$NIX_LDFLAGS" build
  # buildInputs = [ xcbuild ];

  # # temporary install phase until xcodebuild has "install" support
  # installPhase = ''
  #   mkdir -p $out/bin/
  #   install system_cmds-*/Build/Products/Release/* $out/bin/

  #   for n in 1 5 8; do
  #     mkdir -p $out/share/man/man$n
  #     install */*.$n $out/share/man/man$n
  #   done
  # '';

  # For now we just build sysctl because that's all I need... Please open a
  # PR if you need any other utils before we fix the xcodebuild.
  buildPhase = "cc sysctl.tproj/sysctl.c -o sysctl";

  installPhase =
    ''
      mkdir -p $out/bin
      install sysctl $out/bin
      for n in 5 8; do
        mkdir -p $out/share/man/man$n
        install sysctl.tproj/*.$n $out/share/man/man$n
      done
    '';

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ shlevy ];
  };
}
