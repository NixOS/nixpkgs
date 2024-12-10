{
  lib,
  stdenv,
  buildEnv,
  makeFontsConf,
  gnused,
  writeScript,
  xorg,
  bashInteractive,
  xterm,
  xcbuild,
  makeWrapper,
  quartz-wm,
  fontconfig,
  xlsfonts,
  xfontsel,
  ttf_bitstream_vera,
  freefont_ttf,
  liberation_ttf,
  shell ? "${bashInteractive}/bin/bash",
  unfreeFonts ? false,
  extraFontDirs ? [ ],
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
    $sed -i "s|@LAUNCHD_STARTX@|$NIX_LINK/libexec/launchd_startx|" $tmpdir/$agentName
    $sed -i "s|@STARTX@|$NIX_LINK/bin/startx|" $tmpdir/$agentName
    $sed -i "s|@XQUARTZ@|$NIX_LINK/bin/Xquartz|" $tmpdir/$agentName

    cp ${./org.nixos.xquartz.privileged_startx.plist} $tmpdir/$daemonName
    $sed -i "s|@PRIVILEGED_STARTX@|$NIX_LINK/libexec/privileged_startx|" $tmpdir/$daemonName
    $sed -i "s|@PRIVILEGED_STARTX_D@|$NIX_LINK/etc/X11/xinit/privileged_startx.d|" $tmpdir/$daemonName

    sudo cp $tmpdir/$agentName /Library/LaunchAgents/$agentName
    sudo cp $tmpdir/$daemonName /Library/LaunchDaemons/$daemonName
    sudo launchctl load -w /Library/LaunchAgents/$agentName
    sudo launchctl load -w /Library/LaunchDaemons/$daemonName
  '';
  fontDirs =
    [
      ttf_bitstream_vera
      freefont_ttf
      liberation_ttf
      xorg.fontmiscmisc
      xorg.fontcursormisc
    ]
    ++ lib.optionals unfreeFonts [
      xorg.fontbhlucidatypewriter100dpi
      xorg.fontbhlucidatypewriter75dpi
      xorg.fontbh100dpi
    ]
    ++ extraFontDirs;
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
  pkgs = with xorg; [
    # non-xorg
    quartz-wm
    xterm
    fontconfig
    # xorg
    xlsfonts
    xfontsel
    bdftopcf
    fontutil
    iceauth
    libXpm
    lndir
    luit
    makedepend
    mkfontdir
    mkfontscale
    sessreg
    setxkbmap
    smproxy
    twm
    x11perf
    xauth
    xbacklight
    xclock
    xcmsdb
    xcursorgen
    xdm
    xdpyinfo
    xdriinfo
    xev
    xeyes
    xfs
    xgamma
    xhost
    xinput
    xkbcomp
    xkbevd
    xkbutils
    xkill
    xlsatoms
    xlsclients
    xmessage
    xmodmap
    xpr
    xprop
    xrandr
    xrdb
    xrefresh
    xset
    xsetroot
    xvinfo
    xwd
    xwininfo
    xwud
  ];
in
stdenv.mkDerivation {
  pname = "xquartz";
  version = lib.getVersion xorg.xorgserver;

  nativeBuildInputs = [ makeWrapper ];

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

    substituteInPlace $out/bin/startx \
      --replace "bindir=${xorg.xinit}/bin" "bindir=$out/bin" \
      --replace 'defaultserver=${xorg.xorgserver}/bin/X' "defaultserver=$out/bin/Xquartz" \
      --replace "${xorg.xinit}" "$out" \
      --replace "${xorg.xorgserver}" "$out" \
      --replace "eval xinit" "eval $out/bin/xinit" \
      --replace "sysclientrc=/etc/X11/xinit/xinitrc" "sysclientrc=$out/etc/X11/xinit/xinitrc"

    wrapProgram $out/bin/Xquartz \
      --set XQUARTZ_APP $out/Applications/XQuartz.app

    defaultStartX="$out/bin/startx -- $out/bin/Xquartz"

    ${xcbuild}/bin/PlistBuddy $out/Applications/XQuartz.app/Contents/Info.plist <<EOF
    Add :LSEnvironment dictionary
    Add :LSEnvironment:XQUARTZ_DEFAULT_CLIENT string "${xterm}/bin/xterm"
    Add :LSEnvironment:XQUARTZ_DEFAULT_SHELL string "${shell}"
    Add :LSEnvironment:XQUARTZ_DEFAULT_STARTX string "$defaultStartX"
    Add :LSEnvironment:FONTCONFIG_FILE string "$fontsConfPath"
    Save
    EOF

    substituteInPlace $out/etc/X11/xinit/xinitrc \
      --replace ${xorg.xinit} $out \
      --replace xmodmap ${xorg.xmodmap}/bin/xmodmap \
      --replace xrdb ${xorg.xrdb}/bin/xrdb

    mkdir -p $out/etc/X11/xinit/xinitrc.d

    cp ${./10-fontdir.sh} $out/etc/X11/xinit/xinitrc.d/10-fontdir.sh
    substituteInPlace $out/etc/X11/xinit/xinitrc.d/10-fontdir.sh \
      --subst-var-by "SYSTEM_FONTS" "${fonts}/share/X11-fonts/" \
      --subst-var-by "XSET"         "${xorg.xset}/bin/xset"

    cp ${./98-user.sh} $out/etc/X11/xinit/xinitrc.d/98-user.sh

    cat > $out/etc/X11/xinit/xinitrc.d/99-quartz-wm.sh <<EOF
    exec ${quartz-wm}/bin/quartz-wm
    EOF
    chmod +x $out/etc/X11/xinit/xinitrc.d/99-quartz-wm.sh

    substituteInPlace $out/etc/X11/xinit/privileged_startx.d/20-font_cache \
      --replace ${xorg.xinit} $out

    cp ${./font_cache} $out/bin/font_cache
    substituteInPlace $out/bin/font_cache \
      --subst-var-by "shell"           "${stdenv.shell}" \
      --subst-var-by "PATH"            "$out/bin" \
      --subst-var-by "ENCODINGSDIR"    "${xorg.encodings}/share/fonts/X11/encodings" \
      --subst-var-by "MKFONTDIR"       "${xorg.mkfontdir}/bin/mkfontdir" \
      --subst-var-by "MKFONTSCALE"     "${xorg.mkfontscale}/bin/mkfontscale" \
      --subst-var-by "FC_CACHE"        "${fontconfig.bin}/bin/fc-cache" \
      --subst-var-by "FONTCONFIG_FILE" "$fontsConfPath"
  '';

  passthru = {
    inherit pkgs;
  };

  meta = with lib; {
    platforms = platforms.darwin;
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
