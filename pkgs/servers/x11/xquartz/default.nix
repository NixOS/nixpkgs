{ stdenv, lib, buildEnv, makeFontsConf, gnused, writeScript, xorg, bashInteractive, substituteAll, xterm, makeWrapper, ruby
, openssl, quartz-wm, fontconfig, xkeyboard_config, xlsfonts, xfontsel
, ttf_bitstream_vera, freefont_ttf, liberation_ttf_binary
, shell ? "${bashInteractive}/bin/bash"
}:

# ------------
# Installation
# ------------
#
# First, assuming you've previously installed XQuartz from macosforge.com,
# unload and remove the existing launch agents:
#
#   $ sudo launchctl unload /Library/LaunchAgents/org.macosforge.xquartz.startx.plist
#   $ sudo launchctl unload /Library/LaunchDaemons/org.macosforge.xquartz.privileged_startx.plist
#   $ sudo rm /Library/LaunchAgents/org.macosforge.xquartz.startx.plist
#   $ sudo rm /Library/LaunchDaemons/org.macosforge.xquartz.privileged_startx.plist
#
# (You will need to log out for the above changes to take effect.)
#
# Then install xquartz from nixpkgs:
#
#   $ nix-env -i xquartz
#   $ xquartz-install
#
# You'll also want to add the following to your shell's profile (after you
# source nix.sh, so $NIX_LINK points to your user profile):
#
#   if [ "$(uname)" = "Darwin" -a -n "$NIX_LINK" -a -f $NIX_LINK/etc/X11/fonts.conf ]; then
#     export FONTCONFIG_FILE=$NIX_LINK/etc/X11/fonts.conf
#   fi

# A note about dependencies:
# Xquartz wants to exec XQuartz.app, XQuartz.app wants to exec xstart, and
# xstart wants to exec Xquartz, so we must bundle all three to prevent a cycle.
# Coincidentally, this also makes it trivial to install launch agents/daemons
# that point into the user's profile.

let
  installer = writeScript "xquartz-install" ''
    NIX_LINK=$HOME/.nix-profile

    tmpdir=$(/usr/bin/mktemp -d $TMPDIR/xquartz-installer-XXXXXXXX)
    agentName=org.nixos.xquartz.startx.plist
    daemonName=org.nixos.xquartz.privileged_startx.plist
    sed=${gnused}/bin/sed

    cp ${./org.nixos.xquartz.startx.plist} $tmpdir/$agentName
    $sed -i "s|@LAUNCHD_STARTX@|$NIX_LINK/etc/X11/xinit/launchd_startx|" $tmpdir/$agentName
    $sed -i "s|@STARTX@|$NIX_LINK/bin/startx|" $tmpdir/$agentName
    $sed -i "s|@XQUARTZ@|$NIX_LINK/bin/Xquartz|" $tmpdir/$agentName

    cp ${./org.nixos.xquartz.privileged_startx.plist} $tmpdir/$daemonName
    $sed -i "s|@PRIVILEGED_STARTX@|$NIX_LINK/lib/X11/xinit/privileged_startx|" $tmpdir/$daemonName
    $sed -i "s|@PRIVILEGED_STARTX_D@|$NIX_LINK/lib/X11/xinit/privileged_startx.d|" $tmpdir/$daemonName

    sudo cp $tmpdir/$agentName /Library/LaunchAgents/$agentName
    sudo cp $tmpdir/$daemonName /Library/LaunchDaemons/$daemonName
    sudo launchctl load -w /Library/LaunchAgents/$agentName
    sudo launchctl load -w /Library/LaunchDaemons/$daemonName
  '';
  fontDirs = [
    xorg.fontbhlucidatypewriter100dpi
    xorg.fontbhlucidatypewriter75dpi
    ttf_bitstream_vera
    freefont_ttf
    liberation_ttf_binary
    xorg.fontbh100dpi
    xorg.fontmiscmisc
    xorg.fontcursormisc
  ];
  fontsConf = makeFontsConf {
    fontDirectories = fontDirs ++ [
      "/Library/Fonts"
      "~/Library/Fonts"
    ];
  };
  fonts = import ./system-fonts.nix {
    inherit stdenv xorg fontDirs;
  };
  # any X related programs expected to be available via $PATH
  env = buildEnv {
    name = "xquartz-env";
    pathsToLink = [ "/bin" ];
    paths = with xorg; [
      # non-xorg
      quartz-wm xterm fontconfig
      # xorg
      xlsfonts xfontsel
      bdftopcf fontutil iceauth libXpm lndir luit makedepend mkfontdir
      mkfontscale sessreg setxkbmap smproxy twm x11perf xauth xbacklight xclock
      xcmsdb xcursorgen xdm xdpyinfo xdriinfo xev xeyes xfs xgamma xhost
      xinput xkbcomp xkbevd xkbutils xkill xlsatoms xlsclients xmessage xmodmap
      xpr xprop xrandr xrdb xrefresh xset xsetroot xvinfo xwd xwininfo xwud
    ];
  };
in stdenv.mkDerivation {
  name = "xquartz";

  buildInputs = [ ruby makeWrapper ];

  unpackPhase = "sourceRoot=.";

  dontBuild = true;

  installPhase = ''
    cp -rT ${xorg.xinit} $out
    chmod -R u+w $out
    cp -rT ${xorg.xorgserver} $out
    chmod -R u+w $out

    cp ${installer} $out/bin/xquartz-install

    rm -rf $out/LaunchAgents $out/LaunchDaemons

    fontsConfPath=$out/etc/X11/fonts.conf
    cp ${fontsConf} $fontsConfPath

    cp ${./startx} $out/bin/startx
    substituteInPlace $out/bin/startx \
      --replace "@PATH@"              "$out/bin:${env}" \
      --replace "@XAUTH@"             "${xorg.xauth}/bin/xauth" \
      --replace "@FONT_CACHE@"        "$out/bin/font_cache" \
      --replace "@PRIVILEGED_STARTX@" "$out/lib/X11/xinit/privileged_startx" \
      --replace "@DEFAULT_SERVER@"    "$out/bin/Xquartz" \
      --replace "@DEFAULT_CLIENT@"    "${xterm}/bin/xterm" \
      --replace "@XINIT@"             "$out/bin/xinit" \
      --replace "@XINITRC@"           "$out/etc/X11/xinit/xinitrc" \
      --replace "@XKEYBOARD_CONFIG@"  "${xkeyboard_config}/etc/X11/xkb" \
      --replace "@FONTCONFIG_FILE@"   "$fontsConfPath"

    wrapProgram $out/bin/Xquartz \
      --set XQUARTZ_X11 $out/Applications/XQuartz.app/Contents/MacOS/X11 \
      --set XKB_BINDIR "${xorg.xkbcomp}/bin"

    defaultStartX="$out/bin/startx -- $out/bin/Xquartz"

    ruby ${./patch_plist.rb} \
      ${lib.escapeShellArg (builtins.toXML {
        XQUARTZ_DEFAULT_CLIENT = "${xterm}/bin/xterm";
        XQUARTZ_DEFAULT_SHELL  = "${shell}";
        XQUARTZ_DEFAULT_STARTX = "@STARTX@";
        FONTCONFIG_FILE        = "@FONTCONFIG_FILE@";
        XKB_BINDIR             = "${xorg.xkbcomp}/bin";
      })} \
      $out/Applications/XQuartz.app/Contents/Info.plist
    substituteInPlace $out/Applications/XQuartz.app/Contents/Info.plist \
      --replace "@STARTX@"          "$defaultStartX" \
      --replace "@FONTCONFIG_FILE@" "$fontsConfPath"

    mkdir -p $out/lib/X11/xinit/privileged_startx.d
    cp ${./privileged} $out/lib/X11/xinit/privileged_startx.d/privileged
    substituteInPlace $out/lib/X11/xinit/privileged_startx.d/privileged \
      --replace "@PATH@"            "$out/bin:${env}" \
      --replace "@FONTCONFIG_FILE@" "$fontsConfPath" \
      --replace "@FONT_CACHE@"      "$out/bin/font_cache"

    cp ${./font_cache} $out/bin/font_cache
    substituteInPlace $out/bin/font_cache \
      --replace "@PATH@"            "$out/bin:${env}" \
      --replace "@ENCODINGSDIR@"    "${xorg.encodings}/share/fonts/X11/encodings" \
      --replace "@MKFONTDIR@"       "${xorg.mkfontdir}/bin/mkfontdir" \
      --replace "@MKFONTSCALE@"     "${xorg.mkfontscale}/bin/mkfontscale" \
      --replace "@FC_CACHE@"        "${fontconfig.bin}/bin/fc-cache" \
      --replace "@FONTCONFIG_FILE@" "$fontsConfPath"

    cp ${./xinitrc} $out/etc/X11/xinit/xinitrc
    substituteInPlace $out/etc/X11/xinit/xinitrc \
      --replace "@PATH@"            "$out/bin:${env}" \
      --replace "@XSET@"            "${xorg.xset}/bin/xset" \
      --replace "@XMODMAP@"         "${xorg.xmodmap}/bin/xmodmap" \
      --replace "@XRDB@"            "${xorg.xrdb}/bin/xrdb" \
      --replace "@SYSTEM_FONTS@"    "${fonts}/share/X11-fonts/" \
      --replace "@QUARTZ_WM@"       "${quartz-wm}/bin/quartz-wm" \
      --replace "@FONTCONFIG_FILE@" "$fontsConfPath"

    cp ${./X11} $out/Applications/XQuartz.app/Contents/MacOS/X11
    substituteInPlace $out/Applications/XQuartz.app/Contents/MacOS/X11 \
      --replace "@DEFAULT_SHELL@"   "${shell}" \
      --replace "@DEFAULT_STARTX@"  "$defaultStartX" \
      --replace "@DEFAULT_CLIENT@"  "${xterm}/bin/xterm" \
      --replace "@FONTCONFIG_FILE@" "$fontsConfPath"
  '';

  meta = with lib; {
    platforms   = platforms.darwin;
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.mit;
  };
}
