{args, xorg}:
let
   setMalloc0ReturnsNullCrossCompiling = ''
      if test -n "$crossConfig"; then
        configureFlags="$configureFlags --enable-malloc0returnsnull";
      fi
    '';
in
{
  encodings = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [ xorg.mkfontscale ];
  };

  fontcursormisc = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [ xorg.mkfontscale ];
  };

  fontmiscmisc = attrs: attrs // {
    postInstall =
      ''
        ALIASFILE=${xorg.fontalias}/share/fonts/X11/misc/fonts.alias
        test -f $ALIASFILE
        ln -s $ALIASFILE $out/lib/X11/fonts/misc/fonts.alias
      '';
  };

  imake = attrs: attrs // {
    inherit (xorg) xorgcffiles;
    x11BuildHook = ./imake.sh;
    patches = [./imake.patch];
  };

  mkfontdir = attrs: attrs // {
    preBuild = "substituteInPlace mkfontdir.in --replace @bindir@ ${xorg.mkfontscale}/bin";
  };

  libxcb = attrs : attrs // {
    # I only remove python from the original, and add xproto. I don't know how
    # to achieve that referring to attrs.buildInputs.
    # I should use: builtins.unsafeDiscardStringContext
    buildInputs = [args.pkgconfig args.libxslt xorg.libpthreadstubs /*xorg.python*/
        xorg.libXau xorg.xcbproto xorg.libXdmcp ] ++ [ xorg.xproto ];
    nativeBuildInputs = [ args.python ];
  };

  xcbproto = attrs : attrs // {
    # I only remove python from the original.
    buildInputs = [args.pkgconfig  /*xorg.python*/ ];
    nativeBuildInputs = [ args.python ];
  };

  libpciaccess = attrs : attrs // {
    patches = [ ./libpciaccess-apple.patch ];
  };

  libX11 = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
    postInstall =
      ''
        # Remove useless DocBook XML files.
        rm -rf $out/share/doc
      '';
  };

  libXrender = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXxf86vm = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXrandr = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  # Propagate some build inputs because of header file dependencies.
  # Note: most of these are in Requires.private, so maybe builder.sh
  # should propagate them automatically.
  libXt = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
    propagatedBuildInputs = [ xorg.libSM ];
  };

  compositeproto = attrs: attrs // {
    propagatedBuildInputs = [ xorg.fixesproto ];
  };

  libXcomposite = attrs: attrs // {
    propagatedBuildInputs = [ xorg.libXfixes ];
  };

  libXaw = attrs: attrs // {
    propagatedBuildInputs = [ xorg.libXmu ];
  };

  libXft = attrs: attrs // {
    buildInputs = attrs.buildInputs ++
      [ xorg.xproto xorg.libX11 xorg.renderproto ];
    propagatedBuildInputs = [ xorg.libXrender args.freetype args.fontconfig ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXext = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXau];
    propagatedBuildInputs = [ xorg.xproto ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXpm = attrs: attrs // {
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
  };

  setxkbmap = attrs: attrs // {
    postInstall =
      ''
        mkdir -p $out/share
        ln -sfn ${args.xkeyboard_config}/etc/X11 $out/share/X11
      '';
  };

  x11perf = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${args.freetype}/include/freetype2";
    buildInputs = attrs.buildInputs ++ [ args.freetype args.fontconfig ];
  };

  xev = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [ xorg.libXrender ];
  };

  xf86inputevdev = attrs: attrs // {
    preBuild = "sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c";
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputjoystick = attrs: attrs // {
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputsynaptics = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [args.mtdev];
    installFlags = "sdkdir=\${out}/include/xorg configdir=\${out}/include/xorg";
  };

  xf86inputvmmouse = attrs: attrs // {
    configureFlags = [
      "--sysconfdir=$(out)/etc"
      "--with-xorg-conf-dir=$(out)/share/X11/xorg.conf.d"
      "--with-udev-rules-dir=$(out)/lib/udev/rules.d"
    ];
  };

  xdriinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [args.mesa];
  };

  xvinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXext];
  };

  xkbcomp = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-DDFLT_XKB_CONFIG_ROOT=\".\"";
  };

  xkeyboardconfig = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [args.intltool];
  };

  xorgserver = with xorg; attrs: attrs // {
    configureFlags = [
      "--enable-xcsecurity" # enable SECURITY extension
      "--with-default-font-path= "  # there were only paths containing "${prefix}",
                                    # and there are no fonts in this package anyway
    ];
    patches = [./xorgserver-dri-path.patch ./xorgserver-xkbcomp-path.patch];
    buildInputs = attrs.buildInputs ++ [ xtrans ];
    propagatedBuildInputs =
      [ args.zlib args.udev args.mesa args.dbus.libs
        xf86bigfontproto glproto xf86driproto
        compositeproto scrnsaverproto resourceproto
        xf86dgaproto
        dmxproto /*libdmx not used*/ xf86vidmodeproto
        recordproto libXext pixman libXfont
        damageproto xcmiscproto  bigreqsproto
        libpciaccess inputproto xextproto randrproto renderproto
        dri2proto kbproto xineramaproto resourceproto scrnsaverproto videoproto
      ];
    postInstall =
      ''
        rm -fr $out/share/X11/xkb/compiled
        ln -s /var/tmp $out/share/X11/xkb/compiled
      '';
  };

  libSM = attrs: attrs
    // { propagatedBuildInputs = [ xorg.libICE ]; };

  lndir = attrs: attrs // {
    preConfigure = ''
      substituteInPlace lndir.c \
        --replace 'n_dirs--;' ""
    '';
  };

  twm = attrs: attrs // {
    nativeBuildInputs = [args.bison args.flex];
  };

  xbacklight = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXrender];
  };

  xcursorthemes = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.xcursorgen];
    configureFlags = "--with-cursordir=$(out)/share/icons";
  };

  xinput = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXrender];
  };

  xinit = attrs: attrs // {
    configureFlags = "--with-xserver=${xorg.xorgserver}/bin/X";
    propagatedBuildInputs = [ xorg.xauth ];
    prePatch = ''
      sed -i 's|^defaultserverargs="|&-logfile \"$HOME/.xorg.log\"|p' startx.cpp
    '';
  };

  xwd = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXt];
  };
}
