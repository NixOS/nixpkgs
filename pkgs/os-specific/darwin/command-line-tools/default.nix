{ stdenv, callPackage, fetchadc, xpwn, xar, gzip, cpio }:

let
  cmdline_packages = stdenv.mkDerivation {
    name = "osx-10.9-command-line-tools-packages";

    src = fetchadc {
      # Isn't this a beautiful path? Note the subtle differences before and after the slash!
      path   = "Developer_Tools/command_line_tools_os_x_10.9_for_xcode__xcode_6/command_line_tools_for_os_x_10.9_for_xcode_6.dmg";
      sha256 = "0zrpf73r3kfk9pdh6p6j6w1sbw7s2pp0f8rd83660r5hk1y3j5jc";
    };

    phases = [ "unpackPhase" "installPhase" ];

    outputs = [ "devsdk" "cltools" ];

    unpackPhase = ''
      ${xpwn}/bin/hdutil $src extract "Command Line Tools (OS X 10.9).pkg" "Command Line Tools (OS X 10.9).pkg"
      ${xar}/bin/xar -x -f "Command Line Tools (OS X 10.9).pkg"
    '';

    installPhase = ''
      cp -r DevSDK_OSX109.pkg/ $devsdk
      cp -r CLTools_Executables.pkg/ $cltools
    '';

    meta = with stdenv.lib; {
      description = "Basis for the Mac OS command-line tools package";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
      license     = licenses.unfree;
    };
  };
in {
  sdk   = callPackage ./sdk.nix   { inherit cmdline_packages; };
  tools = callPackage ./tools.nix { inherit cmdline_packages; };
}
