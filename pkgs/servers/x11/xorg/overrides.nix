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

  fontbhttf = attrs: attrs // {
    meta = attrs.meta // { license = lib.licenses.unfreeRedistributable; };
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
    outputs = [ "out" "dev" "doc" ];
  };

  xcbproto = attrs : attrs // {
    nativeBuildInputs = [ args.python ];
  };

  libX11 = attrs: attrs // {
    outputs = [ "out" "dev" "man" ];
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
    outputs = [ "out" "dev" ];
  };

  libXdmcp = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
  };

  libXfont = attrs: attrs // {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = [ args.freetype ]; # propagate link reqs. like bzip2
    # prevents "misaligned_stack_error_entering_dyld_stub_binder"
    configureFlags = lib.optionals isDarwin [
      "CFLAGS=-O0"
    ];
  };

  libXxf86vm = attrs: attrs // {
    outputs = [ "out" "dev" ];
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
    outputs = [ "out" "dev" "devdoc" ];
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
    outputs = [ "out" "dev" "doc" ];
  };

  libXcomposite = attrs: attrs // {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = [ xorg.libXfixes ];
  };

  libXaw = attrs: attrs // {
    outputs = [ "out" "dev" "devdoc" ];
    propagatedBuildInputs = [ xorg.libXmu ];
  };

  libXcursor = attrs: attrs // {
    outputs = [ "out" "dev" ];
  };

  libXdamage = attrs: attrs // {
    outputs = [ "out" "dev" ];
  };

  libXft = attrs: attrs // {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = [ xorg.libXrender args.freetype args.fontconfig ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
    # the include files need ft2build.h, and Requires.private isn't enough for us
    postInstall = ''
      sed "/^Requires:/s/$/, freetype2/" -i "$dev/lib/pkgconfig/xft.pc"
    '';
  };

  libXext = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
    propagatedBuildInputs = [ xorg.xproto xorg.libXau ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXfixes = attrs: attrs // {
    outputs = [ "out" "dev" ];
  };

  libXi = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
    propagatedBuildInputs = [ xorg.libXfixes ];
  };

  libXinerama = attrs: attrs // {
    outputs = [ "out" "dev" ];
  };

  libXmu = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
    buildFlags = ''BITMAP_DEFINES=-DBITMAPDIR=\"/no-such-path\"'';
  };

  libXrandr = attrs: attrs // {
    outputs = [ "out" "dev" ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
    propagatedBuildInputs = [xorg.libXrender];
  };

  libSM = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
    propagatedBuildInputs = [ xorg.libICE ];
  };

  libXrender = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
    propagatedBuildInputs = [ xorg.renderproto ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXres = attrs: attrs // {
    outputs = [ "out" "dev" "devdoc" ];
  };

  libXv = attrs: attrs // {
    outputs = [ "out" "dev" "devdoc" ];
  };

  libXvMC = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
    buildInputs = attrs.buildInputs ++ [xorg.renderproto];
  };

  libXp = attrs: attrs // {
    outputs = [ "out" "dev" ];
  };

  libXpm = attrs: attrs // {
    name = "libXpm-3.5.12";
    src = args.fetchurl {
      url = mirror://xorg/individual/lib/libXpm-3.5.12.tar.bz2;
      sha256 = "1v5xaiw4zlhxspvx76y3hq4wpxv7mpj6parqnwdqvpj8vbinsspx";
    };
    outputs = [ "bin" "dev" "out" ]; # tiny man in $bin
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
  };

  libXpresent = attrs: attrs
    // { buildInputs = with xorg; attrs.buildInputs ++ [ libXext libXfixes libXrandr ]; };

  libxkbfile = attrs: attrs // {
    outputs = [ "out" "dev" ]; # mainly to avoid propagation
  };

  libxshmfence = attrs: attrs // {
    outputs = [ "out" "dev" ]; # mainly to avoid propagation
  };

  libpciaccess = attrs: attrs // {
    meta = attrs.meta // { platforms = stdenv.lib.platforms.linux; };
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
    outputs = [ "out" "dev" ];
  };

  xcbutilcursor = attrs: attrs // {
    outputs = [ "out" "dev" ];
    meta = attrs.meta // { maintainers = [ stdenv.lib.maintainers.lovek323 ]; };
  };

  xcbutilimage = attrs: attrs // {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  };

  xcbutilkeysyms = attrs: attrs // {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  };

  xcbutilrenderutil = attrs: attrs // {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  };

  xcbutilwm = attrs: attrs // {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  };

  xf86inputevdev = attrs: attrs // {
    outputs = [ "out" "dev" ]; # to get rid of xorgserver.dev; man is tiny
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
    outputs = [ "out" "dev" ]; # *.pc pulls xorgserver.dev
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

  # Obsolete drivers that don't compile anymore.
  xf86videoark        = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videogeode      = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videoglide      = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videoi128       = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videonewport    = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videoopenchrome = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videotga        = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videov4l        = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videovoodoo     = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videowsfb       = attrs: attrs // { meta = attrs.meta // { broken = true; }; };

  xf86videoamdgpu = attrs: attrs // {
    configureFlags = [ "--with-xorg-conf-dir=$(out)/share/X11/xorg.conf.d" ];
  };

  xf86videoati = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-I${xorg.xorgserver.dev or xorg.xorgserver}/include/xorg";
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

  xorgserver = with xorg; attrs_passed:
    # exchange attrs if abiCompat is set
    let
      attrs = with args;
        if (args.abiCompat == null) then attrs_passed
        else if (args.abiCompat == "1.17") then {
          name = "xorg-server-1.17.4";
          builder = ./builder.sh;
          src = fetchurl {
            url = mirror://xorg/individual/xserver/xorg-server-1.17.4.tar.bz2;
            sha256 = "0mv4ilpqi5hpg182mzqn766frhi6rw48aba3xfbaj4m82v0lajqc";
          };
          buildInputs = [pkgconfig dri2proto dri3proto renderproto libdrm openssl libX11 libXau libXaw libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt ];
          meta.platforms = stdenv.lib.platforms.unix;
        } else if (args.abiCompat == "1.18") then {
            name = "xorg-server-1.18.4";
            builder = ./builder.sh;
            src = fetchurl {
              url = mirror://xorg/individual/xserver/xorg-server-1.18.4.tar.bz2;
              sha256 = "1j1i3n5xy1wawhk95kxqdc54h34kg7xp4nnramba2q8xqfr5k117";
            };
            buildInputs = [pkgconfig dri2proto dri3proto renderproto libdrm openssl libX11 libXau libXaw libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt ];
            meta.platforms = stdenv.lib.platforms.unix;
        } else throw "unsupported xorg abiCompat: ${args.abiCompat}";

    in attrs //
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
        libXfont2
      ];
      # fix_segfault: https://bugs.freedesktop.org/show_bug.cgi?id=91316
      commonPatches = [ ];
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
        outputs = [ "out" "dev" ];
        buildInputs = [ makeWrapper ] ++ commonBuildInputs;
        propagatedBuildInputs = [ libpciaccess args.epoxy ] ++ commonPropagatedBuildInputs ++ lib.optionals stdenv.isLinux [
          args.udev
        ];
        patches = commonPatches;
        configureFlags = [
          "--enable-kdrive"             # not built by default
          "--enable-xephyr"
          "--enable-xcsecurity"         # enable SECURITY extension
          "--with-default-font-path="   # there were only paths containing "${prefix}",
                                        # and there are no fonts in this package anyway
          "--with-xkb-bin-directory=${xorg.xkbcomp}/bin"
          "--with-xkb-path=${xorg.xkeyboardconfig}/share/X11/xkb"
          "--with-xkb-output=$out/share/X11/xkb/compiled"
          "--enable-glamor"
        ];
        postInstall = ''
          rm -fr $out/share/X11/xkb/compiled # otherwise X will try to write in it
          wrapProgram $out/bin/Xvfb \
            --set XORG_DRI_DRIVER_PATH ${args.mesa}/lib/dri
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

  xf86videoxgi = attrs: attrs // {
    patches = [
      # fixes invalid open mode
      # https://cgit.freedesktop.org/xorg/driver/xf86-video-xgi/commit/?id=bd94c475035739b42294477cff108e0c5f15ef67
      (args.fetchpatch {
        url = "https://cgit.freedesktop.org/xorg/driver/xf86-video-xgi/patch/?id=bd94c475035739b42294477cff108e0c5f15ef67";
        sha256 = "0myfry07655adhrpypa9rqigd6rfx57pqagcwibxw7ab3wjay9f6";
      })
      (args.fetchpatch {
        url = "https://cgit.freedesktop.org/xorg/driver/xf86-video-xgi/patch/?id=78d1138dd6e214a200ca66fa9e439ee3c9270ec8";
        sha256 = "0z3643afgrync280zrp531ija0hqxc5mrwjif9nh9lcnzgnz2d6d";
      })
    ];
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

  xrandr = attrs: attrs // {
    postInstall = ''
      rm $out/bin/xkeystone
    '';
  };
}
