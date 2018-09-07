{ args, xorg }:

let
  inherit (args) stdenv makeWrapper;
  inherit (stdenv) lib isDarwin;
  inherit (lib) overrideDerivation;

  malloc0ReturnsNullCrossFlag = stdenv.lib.optional
    (stdenv.hostPlatform != stdenv.buildPlatform)
    "--enable-malloc0returnsnull";
in
{
  bdftopcf = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [ xorg.xproto xorg.fontsproto ];
  };

  bitmap = attrs: attrs // {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ makeWrapper ];
    postInstall = ''
      paths=(
        "$out/share/X11/%T/%N"
        "$out/include/X11/%T/%N"
        "${xorg.xbitmaps}/include/X11/%T/%N"
      )
      wrapProgram "$out/bin/bitmap" \
        --suffix XFILESEARCHPATH : $(IFS=:; echo "''${paths[*]}")
      makeWrapper "$out/bin/bitmap" "$out/bin/bitmap-color" \
        --suffix XFILESEARCHPATH : "$out/share/X11/%T/%N-color"
    '';
  };

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
        cp $ALIASFILE $out/lib/X11/fonts/misc/fonts.alias
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
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ args.python ];
    configureFlags = [ "--enable-xkb" "--enable-xinput" ];
    outputs = [ "out" "dev" "man" "doc" ];
  };

  xcbproto = attrs : attrs // {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ args.python ];
  };

  libX11 = attrs: attrs // {
    outputs = [ "out" "dev" "man" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    preConfigure = ''
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
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  };

  # Propagate some build inputs because of header file dependencies.
  # Note: most of these are in Requires.private, so maybe builder.sh
  # should propagate them automatically.
  libXt = attrs: attrs // {
    preConfigure = ''
      sed 's,^as_dummy.*,as_dummy="\$PATH",' -i configure
    '';
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = [ xorg.libSM ];
    CPP = stdenv.lib.optionalString stdenv.isDarwin "clang -E -";
    outputs = [ "out" "dev" "devdoc" ];
  };

  # See https://bugs.freedesktop.org/show_bug.cgi?id=47792
  # Once the bug is fixed upstream, this can be removed.
  luit = attrs: attrs // {
    configureFlags = [ "--disable-selective-werror" ];
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
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    # the include files need ft2build.h, and Requires.private isn't enough for us
    postInstall = ''
      sed "/^Requires:/s/$/, freetype2/" -i "$dev/lib/pkgconfig/xft.pc"
    '';
  };

  libXext = attrs: attrs // {
    outputs = [ "out" "dev" "man" "doc" ];
    propagatedBuildInputs = [ xorg.xproto xorg.libXau ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  };

  libXfixes = attrs: attrs // {
    outputs = [ "out" "dev" ];
  };

  libXi = attrs: attrs // {
    outputs = [ "out" "dev" "man" "doc" ];
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
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = [xorg.libXrender];
  };

  libSM = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
    propagatedBuildInputs = [ xorg.libICE ];
  };

  libXrender = attrs: attrs // {
    outputs = [ "out" "dev" "doc" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = [ xorg.renderproto ];
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
    name = "libxshmfence-1.3";
    src = args.fetchurl {
      url = mirror://xorg/individual/lib/libxshmfence-1.3.tar.bz2;
      sha256 = "1ir0j92mnd1nk37mrv9bz5swnccqldicgszvfsh62jd14q6k115q";
    };
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

  xf86inputlibinput = attrs: attrs // rec {
    name = "xf86-input-libinput-0.26.0";
    src = args.fetchurl {
      url = "mirror://xorg/individual/driver/${name}.tar.bz2";
      sha256 = "0yrqs88b7yn9nljwlxzn76jfmvf0sh939kzij5b2jvr2qa7mbjmb";
    };
    outputs = [ "out" "dev" ];
    buildInputs = attrs.buildInputs ++ [ args.libinput ];
    installFlags = "sdkdir=\${dev}/include/xorg";
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

    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  };

  # Obsolete drivers that don't compile anymore.
  xf86videoark        = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videogeode      = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videoglide      = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videoi128       = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
  xf86videonewport    = attrs: attrs // { meta = attrs.meta // { broken = true; }; };
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
    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  };

  xf86videoqxl = attrs: attrs // {
    buildInputs =  attrs.buildInputs ++ [ args.spice-protocol ];
  };

  xf86videosiliconmotion = attrs: attrs // {
    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  };

  xdriinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [args.libGL];
  };

  xvinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXext];
  };

  xkbcomp = attrs: attrs // {
    configureFlags = [ "--with-xkb-config-root=${xorg.xkeyboardconfig}/share/X11/xkb" ];
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

  xlsfonts = attrs: attrs // {
    meta = attrs.meta // { license = lib.licenses.mit; };
  };

  xorgserver = with xorg; attrs_passed:
    # exchange attrs if abiCompat is set
    let
      version = (builtins.parseDrvName attrs_passed.name).version;
      attrs = with args;
        if (args.abiCompat == null || lib.hasPrefix args.abiCompat version) then attrs_passed
        else if (args.abiCompat == "1.17") then {
          name = "xorg-server-1.17.4";
          builder = ./builder.sh;
          src = fetchurl {
            url = mirror://xorg/individual/xserver/xorg-server-1.17.4.tar.bz2;
            sha256 = "0mv4ilpqi5hpg182mzqn766frhi6rw48aba3xfbaj4m82v0lajqc";
          };
          nativeBuildInputs = [ pkgconfig ];
          buildInputs = [ dri2proto dri3proto renderproto libdrm openssl libX11 libXau libXaw libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt ];
          meta.platforms = stdenv.lib.platforms.unix;
        } else if (args.abiCompat == "1.18") then {
            name = "xorg-server-1.18.4";
            builder = ./builder.sh;
            src = fetchurl {
              url = mirror://xorg/individual/xserver/xorg-server-1.18.4.tar.bz2;
              sha256 = "1j1i3n5xy1wawhk95kxqdc54h34kg7xp4nnramba2q8xqfr5k117";
            };
            nativeBuildInputs = [ pkgconfig ];
            buildInputs = [ dri2proto dri3proto renderproto libdrm openssl libX11 libXau libXaw libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt ];
            postPatch = stdenv.lib.optionalString stdenv.isLinux "sed '1i#include <malloc.h>' -i include/os.h";
            meta.platforms = stdenv.lib.platforms.unix;
        } else throw "unsupported xorg abiCompat ${args.abiCompat} for ${attrs_passed.name}";

    in attrs //
    (let
      version = (builtins.parseDrvName attrs.name).version;
      commonBuildInputs = attrs.buildInputs ++ [ xtrans ];
      commonPropagatedBuildInputs = [
        args.zlib args.libGL args.libGLU args.dbus
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
        buildInputs = commonBuildInputs ++ [ args.libdrm args.mesa_noglu ];
        propagatedBuildInputs = [ libpciaccess args.epoxy ] ++ commonPropagatedBuildInputs ++ lib.optionals stdenv.isLinux [
          args.udev
        ];
        prePatch = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
          export CFLAGS+=" -D__uid_t=uid_t -D__gid_t=gid_t"
        '';
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
        ] ++ lib.optionals stdenv.hostPlatform.isMusl [
          "--disable-tls"
        ];

        postInstall = ''
          rm -fr $out/share/X11/xkb/compiled # otherwise X will try to write in it
          ( # assert() keeps runtime reference xorgserver-dev in xf86-video-intel and others
            cd "$dev"
            for f in include/xorg/*.h; do
              sed "1i#line 1 \"${attrs.name}/$f\"" -i "$f"
            done
          )
        '';
        passthru.version = version; # needed by virtualbox guest additions
      } else {
        nativeBuildInputs = attrs.nativeBuildInputs ++ [ args.autoreconfHook xorg.utilmacros xorg.fontutil ];
        buildInputs = commonBuildInputs ++ [
          args.bootstrap_cmds args.automake args.autoconf
          args.apple_sdk.libs.Xplugin
          args.apple_sdk.frameworks.Carbon
          args.apple_sdk.frameworks.Cocoa
        ];
        propagatedBuildInputs = commonPropagatedBuildInputs ++ [
          libAppleWM applewmproto
        ];

        # XQuartz patchset
        patches = [
          (args.fetchpatch {
            url = "https://github.com/XQuartz/xorg-server/commit/e88fd6d785d5be477d5598e70d105ffb804771aa.patch";
            sha256 = "1q0a30m1qj6ai924afz490xhack7rg4q3iig2gxsjjh98snikr1k";
            name = "use-cppflags-not-cflags.patch";
          })
          (args.fetchpatch {
            url = "https://github.com/XQuartz/xorg-server/commit/75ee9649bcfe937ac08e03e82fd45d9e18110ef4.patch";
            sha256 = "1vlfylm011y00j8mig9zy6gk9bw2b4ilw2qlsc6la49zi3k0i9fg";
            name = "use-old-mitrapezoids-and-mitriangles-routines.patch";
          })
          (args.fetchpatch {
            url = "https://github.com/XQuartz/xorg-server/commit/c58f47415be79a6564a9b1b2a62c2bf866141e73.patch";
            sha256 = "19sisqzw8x2ml4lfrwfvavc2jfyq2bj5xcf83z89jdxg8g1gdd1i";
            name = "revert-fb-changes-1.patch";
          })
          (args.fetchpatch {
            url = "https://github.com/XQuartz/xorg-server/commit/56e6f1f099d2821e5002b9b05b715e7b251c0c97.patch";
            sha256 = "0zm9g0g1jvy79sgkvy0rjm6ywrdba2xjd1nsnjbxjccckbr6i396";
            name = "revert-fb-changes-2.patch";
          })
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
          mkdir -p $out/Applications
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
    nativeBuildInputs = attrs.nativeBuildInputs ++ [args.bison args.flex];
  };

  xauth = attrs: attrs // {
    doCheck = false; # fails
  };

  xcursorthemes = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.xcursorgen];
    configureFlags = [ "--with-cursordir=$(out)/share/icons" ];
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
    # the update script only works with released tarballs :-/
    name = "xf86-video-intel-2017-10-19";
    src = args.fetchurl {
      url = "http://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/"
          + "4798e18b2b2c8b0a05dc967e6140fd9962bc1a73.tar.gz";
      sha256 = "1zpgbibfpdassswfj68zwhhfpvd2p80rpxw92bis6lv81ssknwby";
    };
    buildInputs = attrs.buildInputs ++ [xorg.libXfixes xorg.libXScrnSaver xorg.pixman];
    nativeBuildInputs = attrs.nativeBuildInputs ++ [args.autoreconfHook xorg.utilmacros];
    configureFlags = [ "--with-default-dri=3" "--enable-tools" ];

    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
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

  xorgcffiles = attrs: attrs // {
    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace $out/lib/X11/config/darwin.cf --replace "/usr/bin/" ""
    '';
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
    configureFlags = [ "--with-cpp=${args.mcpp}/bin/mcpp" ];
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
