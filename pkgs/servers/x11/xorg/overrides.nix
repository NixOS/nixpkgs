{ args, xorg }:

let
  setMalloc0ReturnsNullCrossCompiling = ''
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --enable-malloc0returnsnull";
    fi
  '';

  gitRelease = { libName, version, rev, sha256 } : attrs : attrs // {
    name = libName + "-" + version;
    src = args.fetchgit {
      url = git://anongit.freedesktop.org/xorg/lib/ + libName;
      inherit rev sha256;
    };
    buildInputs = attrs.buildInputs ++ [ xorg.utilmacros  ];
    preConfigure = (attrs.preConfigure or "") + "\n./autogen.sh";
  };

  compose = f: g: x: f (g x);
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

  glamoregl = attrs: attrs // {
    installFlags = "sdkdir=\${out}/include/xorg configdir=\${out}/share/X11/xorg.conf.d";
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
    nativeBuildInputs = [ args.python ];
    configureFlags = "--enable-xkb";
  };

  xcbproto = attrs : attrs // {
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

  libXxf86vm = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXrandr = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
    propagatedBuildInputs = [xorg.libXrender];
  };

  # Propagate some build inputs because of header file dependencies.
  # Note: most of these are in Requires.private, so maybe builder.sh
  # should propagate them automatically.
  libXt = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
    propagatedBuildInputs = [ xorg.libSM ];
  };

  # See https://bugs.freedesktop.org/show_bug.cgi?id=47792
  # Once the bug is fixed upstream, this can be removed.
  luit = attrs: attrs // {
    configureFlags = "--disable-selective-werror";
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
    propagatedBuildInputs = [ xorg.libXrender args.freetype args.fontconfig ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXext = attrs: attrs // {
    propagatedBuildInputs = [ xorg.xproto xorg.libXau ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libSM = attrs: attrs
    // { propagatedBuildInputs = [ xorg.libICE ]; };

  libXrender = attrs: attrs
    // { preConfigure = setMalloc0ReturnsNullCrossCompiling; };

  libXvMC = attrs: attrs
    // { buildInputs = attrs.buildInputs ++ [xorg.renderproto]; };

  libXpm = attrs: attrs // {
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
  };

  setxkbmap = attrs: attrs // {
    postInstall =
      ''
        mkdir -p $out/share
        ln -sfn ${xorg.xkeyboardconfig}/etc/X11 $out/share/X11
      '';
  };

  utilmacros = attrs: attrs // { # not needed for releases, we propagate the needed tools
    propagatedBuildInputs = with args; [ automake autoconf libtool ];
  };

  x11perf = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [ args.freetype args.fontconfig ];
  };

  xf86inputevdev = attrs: attrs // {
    preBuild = "sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c";
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputmouse = attrs: attrs // {
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputjoystick = attrs: attrs // {
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputsynaptics = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [args.mtdev];
    installFlags = "sdkdir=\${out}/include/xorg configdir=\${out}/share/X11/xorg.conf.d";
  };

  xf86inputvmmouse = attrs: attrs // {
    configureFlags = [
      "--sysconfdir=$(out)/etc"
      "--with-xorg-conf-dir=$(out)/share/X11/xorg.conf.d"
      "--with-udev-rules-dir=$(out)/lib/udev/rules.d"
    ];
  };

  xf86videoati = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.glamoregl}/include/xorg";
  };

  xf86videonv = attrs: attrs // {
    patches = [( args.fetchpatch {
      url = http://cgit.freedesktop.org/xorg/driver/xf86-video-nv/patch/?id=fc78fe98222b0204b8a2872a529763d6fe5048da;
      sha256 = "0i2ddgqwj6cfnk8f4r73kkq3cna7hfnz7k3xj3ifx5v8mfiva6gw";
    })];
  };

  xf86videovmware = attrs: attrs // {
    buildInputs =  attrs.buildInputs ++ [ args.mesa_drivers ]; # for libxatracker
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

    #TODO: resurrect patches for US_intl?
    patches = [ ./xkeyboard-config-eo.patch ];

    # 1: compatibility for X11/xkb location
    # 2: I think pkgconfig/ is supposed to be in /lib/
    postInstall = ''
      ln -s share "$out/etc"
      mkdir "$out/lib" && ln -s ../share/pkgconfig "$out/lib/"
    '';
  };

  xorgserver = with xorg; attrs: attrs // {
    configureFlags = [
      "--enable-xcsecurity" # enable SECURITY extension
      "--with-default-font-path= "  # there were only paths containing "${prefix}",
                                    # and there are no fonts in this package anyway
    ];
    patches = [ ./xorgserver-xkbcomp-path.patch ];
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
    passthru.version = (builtins.parseDrvName attrs.name).version; # needed by virtualbox guest additions
  };


  lndir = attrs: attrs // {
    preConfigure = ''
      substituteInPlace lndir.c \
        --replace 'n_dirs--;' ""
    '';
  };

  twm = attrs: attrs // {
    nativeBuildInputs = [args.bison args.flex];
  };

  xcursorthemes = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.xcursorgen];
    configureFlags = "--with-cursordir=$(out)/share/icons";
  };

  xinput = attrs: attrs // {
    propagatedBuildInputs = [xorg.libXfixes];
  };

  xinit = attrs: attrs // {
    configureFlags = "--with-xserver=${xorg.xorgserver}/bin/X";
    propagatedBuildInputs = [ xorg.xauth ];
    prePatch = ''
      sed -i 's|^defaultserverargs="|&-logfile \"$HOME/.xorg.log\"|p' startx.cpp
    '';
  };

  xf86videointel = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXfixes];
  };

  xwd = attrs: attrs // {
    buildInputs = with xorg; attrs.buildInputs ++ [libXt libxkbfile];
  };
}
