{args, xorg}:
let
   setMalloc0ReturnsNullCrossCompiling = ''
      if test -n "$crossConfig"; then
        configureFlags="$configureFlags --enable-malloc0returnsnull";
      fi
    '';
in
{

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
    buildNativeInputs = [ args.python ];
  };

  xcbproto = attrs : attrs // {
    # I only remove python from the original.
    buildInputs = [args.pkgconfig  /*xorg.python*/ ];
    buildNativeInputs = [ args.python ];
  };

  pixman = attrs : attrs // {
    buildInputs = [ args.pkgconfig ];
    buildNativeInputs = [ args.perl ];
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
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.kbproto xorg.libxkbfile xorg.randrproto xorg.pixman];
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputkeyboard = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.pixman];
  };

  xf86inputmouse = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.pixman];
  };

  xf86inputsynaptics = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [args.mtdev xorg.pixman];
    installFlags = "sdkdir=\${out}/include/xorg configdir=\${out}/include/xorg";
  };

  xf86videointel = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa];
  };

  xf86videosis = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa];
  };

  xf86videoati = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa xorg.pixman];
  };

  xf86videocirrus = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.pixman];
  };

  xf86videofbdev = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.pixman];
  };

  xf86videoopenchrome = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.pixman xorg.glproto args.mesa];
  };

  xf86videonv = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.pixman];
  };

  xf86videovesa = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.pixman}/include/pixman-1";
    buildInputs = attrs.buildInputs ++ [xorg.pixman];
  };

  xdriinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa];
  };

  xvinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXext];
  };

  xkbcomp = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-DDFLT_XKB_CONFIG_ROOT=\".\"";
  };

  xorgserver = attrs: attrs // {
    configureFlags = "--enable-xcsecurity"; # enable SECURITY extension
    patches = [./xorgserver-dri-path.patch ./xorgserver-xkbcomp-path.patch];
    buildInputs = attrs.buildInputs ++
      [ args.zlib args.udev args.mesa args.dbus.libs
        xorg.xf86bigfontproto xorg.glproto xorg.xf86driproto
        xorg.compositeproto xorg.scrnsaverproto xorg.resourceproto
        xorg.xineramaproto xorg.xf86dgaproto
        xorg.dmxproto xorg.libdmx xorg.xf86vidmodeproto
        xorg.recordproto xorg.libXext xorg.pixman xorg.libXfont
        xorg.damageproto xorg.xcmiscproto xorg.xtrans xorg.bigreqsproto
      ];
    propagatedBuildInputs =
      [ xorg.libpciaccess xorg.inputproto xorg.xextproto xorg.randrproto
        xorg.dri2proto xorg.kbproto
      ];
    postInstall =
      ''
        rm -fr $out/share/X11/xkb/compiled
        ln -s /var/tmp $out/share/X11/xkb/compiled
      '';
  };

  xorgserver_1_13_0 = attrs: attrs // {
    configureFlags = "--enable-xcsecurity"; # enable SECURITY extension
    patches = [./xorgserver-dri-path.patch ./xorgserver-xkbcomp-path.patch];
    buildInputs = attrs.buildInputs ++
      [ args.zlib args.udev args.mesa args.dbus.libs
        xorg.xf86bigfontproto xorg.glproto xorg.xf86driproto
        xorg.compositeproto xorg.scrnsaverproto xorg.resourceproto
        xorg.xineramaproto xorg.xf86dgaproto
        xorg.dmxproto xorg.libdmx xorg.xf86vidmodeproto
        xorg.recordproto xorg.libXext xorg.pixman xorg.libXfont
        xorg.damageproto xorg.xcmiscproto xorg.xtrans xorg.bigreqsproto
      ];
    propagatedBuildInputs =
      [ xorg.libpciaccess xorg.inputproto xorg.xextproto xorg.randrproto
        xorg.dri2proto xorg.kbproto
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
    buildNativeInputs = [args.bison args.flex];
  };

  xbacklight = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXrender];
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
