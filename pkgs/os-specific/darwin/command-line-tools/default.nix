{ stdenv, fetchadc, xar, gzip, cpio }:

let
  name = "command-line-tools-mac-os-10.9";

  pkg = { installPhase }: stdenv.mkDerivation {
    name = "${name}.pkg";

    phases = [ "installPhase" ];

    inherit installPhase;

    meta = with stdenv.lib; {
      description = "Developer tools .pkg file";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
      license     = licenses.unfree;
    };
  };

  basic = pkg: stdenv.mkDerivation {
    inherit name;

    phases = [ "unpackPhase" "installPhase" ];

    outputs = [ "sdk" "tools" ];

    unpackPhase = ''
      ${xar}/bin/xar -x -f "${pkg}"
    '';

    installPhase = ''
      start="$(pwd)"
      mkdir -p $sdk
      mkdir -p $tools

      cd $sdk
      cat $start/DevSDK_OSX109.pkg/Payload | ${gzip}/bin/gzip -d | ${cpio}/bin/cpio -idm

      cd $tools
      cat $start/CLTools_Executables.pkg/Payload | ${gzip}/bin/gzip -d | ${cpio}/bin/cpio -idm
    '';

    meta = with stdenv.lib; {
      description = "Mac OS command-line developer tools and SDK";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
      license     = licenses.unfree;
    };
  };
in rec {
  dmg = fetchadc {
    # Isn't this a beautiful path? Note the subtle differences before and after the slash!
    path   = "Developer_Tools/command_line_tools_os_x_10.9_for_xcode__xcode_6/command_line_tools_for_os_x_10.9_for_xcode_6.dmg";
    sha256 = "0zrpf73r3kfk9pdh6p6j6w1sbw7s2pp0f8rd83660r5hk1y3j5jc";
  };

  pure = { xpwn }: basic (pkg {
    installPhase = ''
      ${xpwn}/bin/hdutil ${dmg} extract "Command Line Tools (OS X 10.9).pkg" $out
    '';
  });

  impure = basic (pkg {
    installPhase = ''
      /usr/bin/hdiutil attach ${dmg} -mountpoint clt-mount -nobrowse
      cp "clt-mount/Command Line Tools (OS X 10.9).pkg" $out
      /usr/bin/hdiutil unmount clt-mount
    '';
  });
}
