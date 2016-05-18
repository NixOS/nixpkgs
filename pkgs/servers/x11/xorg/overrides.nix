{ args, xorg }:

let
  inherit (args) stdenv makeWrapper;
  inherit (stdenv) lib isDarwin;
  inherit (lib) overrideDerivation;

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
    patches = [./imake.patch ./imake-cc-wrapper-uberhack.patch];
    setupHook = if stdenv.isDarwin then ./darwin-imake-setup-hook.sh else null;
    CFLAGS = [ "-DIMAKE_COMPILETIME_CPP=\\\"${if stdenv.isDarwin
      then "${args.tradcpp}/bin/cpp"
      else "gcc"}\\\""
    ];
    tradcpp = if stdenv.isDarwin then args.tradcpp else null;
  };

  mkfontdir = attrs: attrs // {
    preBuild = "substituteInPlace mkfontdir.in --replace @bindir@ ${xorg.mkfontscale}/bin";
  };

  mkfontscale = attrs: attrs // {
    patches = lib.singleton (args.fetchpatch {
      name = "mkfontscale-fix-sig11.patch";
      url = "https://bugs.freedesktop.org/attachment.cgi?id=113951";
      sha256 = "0i2xf768mz8kvm7i514v0myna9m6jqw82f9a03idabdpamxvwnim";
    });
    patchFlags = [ "-p0" ];
  };

  libxcb = attrs : attrs // {
    nativeBuildInputs = [ args.python ];
    configureFlags = "--enable-xkb --enable-xinput";
    outputs = [ "dev" "out" "doc" ];
  };

  xcbproto = attrs : attrs // {
    nativeBuildInputs = [ args.python ];
  };

  libX11 = attrs: attrs // {
    outputs = [ "dev" "out" "man" ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling + ''
      sed 's,^as_dummy.*,as_dummy="\$PATH",' -i configure
    '';
    postInstall =
      ''
        # Remove useless DocBook XML files.
        rm -rf $out/share/doc
      '';
    CPP = stdenv.lib.optionalString stdenv.isDarwin "clang -E -";
  };

  libAppleWM = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [ args.apple_sdk.frameworks.ApplicationServices ];
    preConfigure = ''
      substituteInPlace src/Makefile.in --replace -F/System -F${args.apple_sdk.frameworks.ApplicationServices}
    '';
  };

  libXau = attrs: attrs // {
    outputs = [ "dev" "out" ];
  };

  libXdmcp = attrs: attrs // {
    outputs = [ "dev" "out" "doc" ];
  };

  libXfont = attrs: attrs // {
    outputs = [ "dev" "out" ];
    propagatedBuildInputs = [ args.freetype ]; # propagate link reqs. like bzip2
    # prevents "misaligned_stack_error_entering_dyld_stub_binder"
    configureFlags = lib.optionals isDarwin [
      "CFLAGS=-O0"
    ];
  };

  libXxf86vm = attrs: attrs // {
    outputs = [ "dev" "out" ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  # Propagate some build inputs because of header file dependencies.
  # Note: most of these are in Requires.private, so maybe builder.sh
  # should propagate them automatically.
  libXt = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling + ''
      sed 's,^as_dummy.*,as_dummy="\$PATH",' -i configure
    '';
    propagatedBuildInputs = [ xorg.libSM ];
    CPP = stdenv.lib.optionalString stdenv.isDarwin "clang -E -";
    outputs = [ "dev" "out" "docdev" ];
  };

  # See https://bugs.freedesktop.org/show_bug.cgi?id=47792
  # Once the bug is fixed upstream, this can be removed.
  luit = attrs: attrs // {
    configureFlags = "--disable-selective-werror";
  };

  compositeproto = attrs: attrs // {
    propagatedBuildInputs = [ xorg.fixesproto ];
  };

  libICE = attrs: attrs // {
    outputs = [ "dev" "out" "doc" ];
  };

  libXcomposite = attrs: attrs // {
    outputs = [ "dev" "out" ];
    propagatedBuildInputs = [ xorg.libXfixes ];
  };

  libXaw = attrs: attrs // {
    outputs = [ "dev" "out" "docdev" ];
    propagatedBuildInputs = [ xorg.libXmu ];
  };

  libXcursor = attrs: attrs // {
    outputs = [ "dev" "out" ];
  };

  libXdamage = attrs: attrs // {
    outputs = [ "dev" "out" ];
  };

  libXft = attrs: attrs // {
    outputs = [ "dev" "out" ];
    propagatedBuildInputs = [ xorg.libXrender args.freetype args.fontconfig ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
    # the include files need ft2build.h, and Requires.private isn't enough for us
    postInstall = ''
      sed "/^Requires:/s/$/, freetype2/" -i "$dev/lib/pkgconfig/xft.pc"
    '';
  };

  libXext = attrs: attrs // {
    outputs = [ "dev" "out" "doc" ];
    propagatedBuildInputs = [ xorg.xproto xorg.libXau ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXfixes = attrs: attrs // {
    outputs = [ "dev" "out" ];
  };

  libXi = attrs: attrs // {
    outputs = [ "dev" "out" "doc" ];
  };

  libXinerama = attrs: attrs // {
    outputs = [ "dev" "out" ];
  };

  libXmu = attrs: attrs // {
    outputs = [ "dev" "out" "doc" ];
    buildFlags = ''BITMAP_DEFINES=-DBITMAPDIR=\"/no-such-path\"'';
  };

  libXrandr = attrs: attrs // {
    outputs = [ "dev" "out" ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
    propagatedBuildInputs = [xorg.libXrender];
  };

  libSM = attrs: attrs // {
    outputs = [ "dev" "out" "doc" ];
    propagatedBuildInputs = [ xorg.libICE ];
  };

  libXrender = attrs: attrs // {
    outputs = [ "dev" "out" "doc" ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXres = attrs: attrs // {
    outputs = [ "dev" "out" "docdev" ];
  };

  libXv = attrs: attrs // {
    outputs = [ "dev" "out" "docdev" ];
  };

  libXvMC = attrs: attrs // {
    outputs = [ "dev" "out" "doc" ];
    buildInputs = attrs.buildInputs ++ [xorg.renderproto];
  };

  libXpm = attrs: attrs // {
    outputs = [ "dev" "out" "bin" ]; # tiny man in $bin
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
  };

  libXpresent = attrs: attrs
    // { buildInputs = with xorg; attrs.buildInputs ++ [ libXext libXfixes libXrandr ]; };

  libxkbfile = attrs: attrs // {
    outputs = [ "dev" "out" ]; # mainly to avoid propagation
  };

  libxshmfence = attrs: attrs // {
    outputs = [ "dev" "out" ]; # mainly to avoid propagation
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

  xcbutil = attrs: attrs // {
    outputs = [ "dev" "out" ];
  };

  xcbutilcursor = attrs: attrs // {
    outputs = [ "dev" "out" ];
    meta.maintainers = [ stdenv.lib.maintainers.lovek323 ];
  };

  xcbutilimage = attrs: attrs // {
    outputs = [ "dev" "out" ]; # mainly to get rid of propagating others
  };

  xcbutilkeysyms = attrs: attrs // {
    outputs = [ "dev" "out" ]; # mainly to get rid of propagating others
  };

  xcbutilrenderutil = attrs: attrs // {
    outputs = [ "dev" "out" ]; # mainly to get rid of propagating others
  };

  xcbutilwm = attrs: attrs // {
    outputs = [ "dev" "out" ]; # mainly to get rid of propagating others
  };

  xf86inputevdev = attrs: attrs // {
    preBuild = "sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c";
    installFlags = "sdkdir=\${out}/include/xorg";
    buildInputs = attrs.buildInputs ++ [ args.mtdev args.libevdev ];
  };

  xf86inputmouse = attrs: attrs // {
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputjoystick = attrs: attrs // {
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputlibinput = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [ args.libinput ];
    installFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86inputsynaptics = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [args.mtdev args.libevdev];
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

  xf86videoqxl = attrs: attrs // {
    buildInputs =  attrs.buildInputs ++ [ args.spice_protocol ];
  };

  xdriinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [args.mesa];
  };

  xvinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXext];
  };

  xkbcomp = attrs: attrs // {
    configureFlags = "--with-xkb-config-root=${xorg.xkeyboardconfig}/share/X11/xkb";
  };

  xkeyboardconfig = attrs: attrs // {

    buildInputs = attrs.buildInputs ++ [args.intltool];

    #TODO: resurrect patches for US_intl?
    patches = [ ./xkeyboard-config-eo.patch ];

    # 1: compatibility for X11/xkb location
    # 2: I think pkgconfig/ is supposed to be in /lib/
    postInstall = ''
      ln -s share "$out/etc"
      mkdir -p "$out/lib" && ln -s ../share/pkgconfig "$out/lib/"
    '';
  };

  xorgserver = with xorg; attrs: attrs //
    (let
      version = (builtins.parseDrvName attrs.name).version;
      commonBuildInputs = attrs.buildInputs ++ [ xtrans ];
      commonPropagatedBuildInputs = [
        args.zlib args.mesa args.dbus
        xf86bigfontproto glproto xf86driproto
        compositeproto scrnsaverproto resourceproto
        xf86dgaproto
        dmxproto /*libdmx not used*/ xf86vidmodeproto
        recordproto libXext pixman libXfont libxshmfence args.libunwind
        damageproto xcmiscproto  bigreqsproto
        inputproto xextproto randrproto renderproto presentproto
        dri2proto dri3proto kbproto xineramaproto resourceproto scrnsaverproto videoproto
      ];
      # fix_segfault: https://bugs.freedesktop.org/show_bug.cgi?id=91316
      commonPatches = [ ./xorgserver-xkbcomp-path.patch ];
      # XQuartz requires two compilations: the first to get X / XQuartz,
      # and the second to get Xvfb, Xnest, etc.
      darwinOtherX = overrideDerivation xorgserver (oldAttrs: {
        configureFlags = oldAttrs.configureFlags ++ [
          "--disable-xquartz"
          "--enable-xorg"
          "--enable-xvfb"
          "--enable-xnest"
          "--enable-kdrive"
        ];
        postInstall = ":"; # prevent infinite recursion
      });
    in
      if (!isDarwin)
      then {
        outputs = [ "dev" "out" ];
        buildInputs = [ makeWrapper ] ++ commonBuildInputs;
        propagatedBuildInputs = [ libpciaccess ] ++ commonPropagatedBuildInputs ++ lib.optionals stdenv.isLinux [
          args.udev
        ];
        patches = commonPatches;
        configureFlags = [
          "--enable-kdrive"             # not built by default
          "--enable-xephyr"
          "--enable-xcsecurity"         # enable SECURITY extension
          "--with-default-font-path="   # there were only paths containing "${prefix}",
                                        # and there are no fonts in this package anyway
        ];
        postInstall = ''
          rm -fr $out/share/X11/xkb/compiled
          ln -s /var/tmp $out/share/X11/xkb/compiled
          wrapProgram $out/bin/Xephyr \
            --set XKB_BINDIR "${xorg.xkbcomp}/bin" \
            --add-flags "-xkbdir ${xorg.xkeyboardconfig}/share/X11/xkb"
          wrapProgram $out/bin/Xvfb \
            --set XKB_BINDIR "${xorg.xkbcomp}/bin" \
            --set XORG_DRI_DRIVER_PATH ${args.mesa}/lib/dri \
            --add-flags "-xkbdir ${xorg.xkeyboardconfig}/share/X11/xkb"
          ( # assert() keeps runtime reference xorgserver-dev in xf86-video-intel and others
            cd "$dev"
            for f in include/xorg/*.h; do
              sed "1i#line 1 \"${attrs.name}/$f\"" -i "$f"
            done
          )
        '';
        passthru.version = version; # needed by virtualbox guest additions
      } else {
        buildInputs = commonBuildInputs ++ [
          args.bootstrap_cmds args.automake args.autoconf
          args.apple_sdk.libs.Xplugin
          args.apple_sdk.frameworks.Carbon
          args.apple_sdk.frameworks.Cocoa
        ];
        propagatedBuildInputs = commonPropagatedBuildInputs ++ [
          libAppleWM applewmproto
        ];
        # Patches can be pulled from the server-*-apple branches of:
        # http://cgit.freedesktop.org/~jeremyhu/xserver/
        patches = commonPatches ++ [
          ./darwin/0002-sdksyms.sh-Use-CPPFLAGS-not-CFLAGS.patch
          ./darwin/0004-Use-old-miTrapezoids-and-miTriangles-routines.patch
          ./darwin/0006-fb-Revert-fb-changes-that-broke-XQuartz.patch
          ./darwin/private-extern.patch
          ./darwin/bundle_main.patch
          ./darwin/stub.patch
        ];
        configureFlags = [
          # note: --enable-xquartz is auto
          "CPPFLAGS=-I${./darwin/dri}"
          "--with-default-font-path="
          "--with-apple-application-name=XQuartz"
          "--with-apple-applications-dir=\${out}/Applications"
          "--with-bundle-id-prefix=org.nixos.xquartz"
          "--with-sha1=CommonCrypto"
        ];
        preConfigure = ''
          ensureDir $out/Applications
          export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error"
          substituteInPlace hw/xquartz/pbproxy/Makefile.in --replace -F/System -F${args.apple_sdk.frameworks.ApplicationServices}
        '';
        postInstall = ''
          rm -fr $out/share/X11/xkb/compiled
          ln -s /var/tmp $out/share/X11/xkb/compiled

          cp -rT ${darwinOtherX}/bin $out/bin
          rm -f $out/bin/X
          ln -s Xquartz $out/bin/X

          cp ${darwinOtherX}/share/man -rT $out/share/man
        '' ;
        passthru.version = version;
      });

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
    stdenv = if isDarwin then args.clangStdenv else stdenv;
    buildInputs = attrs.buildInputs ++ lib.optional isDarwin args.bootstrap_cmds;
    configureFlags = [
      "--with-xserver=${xorg.xorgserver.out}/bin/X"
    ] ++ lib.optionals isDarwin [
      "--with-bundle-id-prefix=org.nixos.xquartz"
      "--with-launchdaemons-dir=\${out}/LaunchDaemons"
      "--with-launchagents-dir=\${out}/LaunchAgents"
    ];
    propagatedBuildInputs = [ xorg.xauth ]
                         ++ lib.optionals isDarwin [ xorg.libX11 xorg.xproto ];
    prePatch = ''
      sed -i 's|^defaultserverargs="|&-logfile \"$HOME/.xorg.log\"|p' startx.cpp
    '';
  };

  xf86videointel = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXfixes];
    nativeBuildInputs = [args.autoreconfHook xorg.utilmacros];
  };

  xwd = attrs: attrs // {
    buildInputs = with xorg; attrs.buildInputs ++ [libXt libxkbfile];
  };

  kbproto = attrs: attrs // {
    outputs = [ "out" "doc" ];
  };

  xextproto = attrs: attrs // {
    outputs = [ "out" "doc" ];
  };

  xproto = attrs: attrs // {
    outputs = [ "out" "doc" ];
  };

  xrdb = attrs: attrs // {
    configureFlags = "--with-cpp=${args.mcpp}/bin/mcpp";
  };

  sessreg = attrs: attrs // {
    preBuild = "sed -i 's|gcc -E|gcc -E -P|' man/Makefile";
  };

}
