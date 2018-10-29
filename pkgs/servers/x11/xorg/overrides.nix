{ abiCompat ? null,
  stdenv, makeWrapper, lib, fetchurl, fetchpatch,

  automake, autoconf, libtool, intltool, mtdev, libevdev, libinput,
  python, freetype, apple_sdk, tradcpp, fontconfig,
  libGL, spice-protocol, zlib, libGLU, dbus, libunwind, libdrm,
  mesa_noglu, udev, bootstrap_cmds, bison, flex, clangStdenv, autoreconfHook,
  mcpp, epoxy, openssl, pkgconfig, llvm_6 }:

let
  inherit (stdenv) lib isDarwin;
  inherit (lib) overrideDerivation;

  malloc0ReturnsNullCrossFlag = stdenv.lib.optional
    (stdenv.hostPlatform != stdenv.buildPlatform)
    "--enable-malloc0returnsnull";
in
self: super:
{
  bdftopcf = super.bdftopcf.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ self.xproto self.fontsproto ];
  });

  bitmap = super.bitmap.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ makeWrapper ];
    postInstall = ''
      paths=(
        "$out/share/X11/%T/%N"
        "$out/include/X11/%T/%N"
        "${self.xbitmaps}/include/X11/%T/%N"
      )
      wrapProgram "$out/bin/bitmap" \
        --suffix XFILESEARCHPATH : $(IFS=:; echo "''${paths[*]}")
      makeWrapper "$out/bin/bitmap" "$out/bin/bitmap-color" \
        --suffix XFILESEARCHPATH : "$out/share/X11/%T/%N-color"
    '';
  });

  encodings = super.encodings.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ self.mkfontscale ];
  });

  fontbhttf = super.fontbhttf.overrideAttrs (attrs: {
    meta = attrs.meta // { license = lib.licenses.unfreeRedistributable; };
  });

  fontcursormisc = super.fontcursormisc.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ self.mkfontscale ];
  });

  fontmiscmisc = super.fontmiscmisc.overrideAttrs (attrs: {
    postInstall =
      ''
        ALIASFILE=${self.fontalias}/share/fonts/X11/misc/fonts.alias
        test -f $ALIASFILE
        cp $ALIASFILE $out/lib/X11/fonts/misc/fonts.alias
      '';
  });

  imake = super.imake.overrideAttrs (attrs: {
    inherit (self) xorgcffiles;
    x11BuildHook = ./imake.sh;
    patches = [./imake.patch ./imake-cc-wrapper-uberhack.patch];
    setupHook = if stdenv.isDarwin then ./darwin-imake-setup-hook.sh else null;
    CFLAGS = [ "-DIMAKE_COMPILETIME_CPP=\\\"${if stdenv.isDarwin
      then "${tradcpp}/bin/cpp"
      else "gcc"}\\\""
    ];
    tradcpp = if stdenv.isDarwin then tradcpp else null;
  });

  mkfontdir = super.mkfontdir.overrideAttrs (attrs: {
    preBuild = "substituteInPlace mkfontdir.in --replace @bindir@ ${self.mkfontscale}/bin";
  });

  mkfontscale = super.mkfontscale.overrideAttrs (attrs: {
    patches = lib.singleton (fetchpatch {
      name = "mkfontscale-fix-sig11.patch";
      url = "https://bugs.freedesktop.org/attachment.cgi?id=113951";
      sha256 = "0i2xf768mz8kvm7i514v0myna9m6jqw82f9a03idabdpamxvwnim";
    });
    patchFlags = [ "-p0" ];
  });

  libxcb = super.libxcb.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ python ];
    configureFlags = [ "--enable-xkb" "--enable-xinput" ];
    outputs = [ "out" "dev" "man" "doc" ];
  });

  xcbproto = super.xcbproto.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ python ];
  });

  libX11 = super.libX11.overrideAttrs (attrs: {
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
  });

  libAppleWM = super.libAppleWM.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ apple_sdk.frameworks.ApplicationServices ];
    preConfigure = ''
      substituteInPlace src/Makefile.in --replace -F/System -F${apple_sdk.frameworks.ApplicationServices}
    '';
  });

  libXau = super.libXau.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXdmcp = super.libXdmcp.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
  });

  libXfont = super.libXfont.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = [ freetype ]; # propagate link reqs. like bzip2
    # prevents "misaligned_stack_error_entering_dyld_stub_binder"
    configureFlags = lib.optionals isDarwin [
      "CFLAGS=-O0"
    ];
  });

  libXxf86vm = super.libXxf86vm.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });

  # Propagate some build inputs because of header file dependencies.
  # Note: most of these are in Requires.private, so maybe builder.sh
  # should propagate them automatically.
  libXt = super.libXt.overrideAttrs (attrs: {
    preConfigure = ''
      sed 's,^as_dummy.*,as_dummy="\$PATH",' -i configure
    '';
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = [ self.libSM ];
    CPP = stdenv.lib.optionalString stdenv.isDarwin "clang -E -";
    outputs = [ "out" "dev" "devdoc" ];
  });

  # See https://bugs.freedesktop.org/show_bug.cgi?id=47792
  # Once the bug is fixed upstream, this can be removed.
  luit = super.luit.overrideAttrs (attrs: {
    configureFlags = [ "--disable-selective-werror" ];
  });

  compositeproto = super.compositeproto.overrideAttrs (attrs: {
    propagatedBuildInputs = [ self.fixesproto ];
  });

  libICE = super.libICE.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
  });

  libXcomposite = super.libXcomposite.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = [ self.libXfixes ];
  });

  libXaw = super.libXaw.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "devdoc" ];
    propagatedBuildInputs = [ self.libXmu ];
  });

  libXcursor = super.libXcursor.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXdamage = super.libXdamage.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXft = super.libXft.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = [ self.libXrender freetype fontconfig ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    # the include files need ft2build.h, and Requires.private isn't enough for us
    postInstall = ''
      sed "/^Requires:/s/$/, freetype2/" -i "$dev/lib/pkgconfig/xft.pc"
    '';
    passthru = {
      inherit freetype fontconfig;
    };
  });

  libXext = super.libXext.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "man" "doc" ];
    propagatedBuildInputs = [ self.xproto self.libXau ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });

  libXfixes = super.libXfixes.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXi = super.libXi.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "man" "doc" ];
    propagatedBuildInputs = [ self.libXfixes ];
  });

  libXinerama = super.libXinerama.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXmu = super.libXmu.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
    buildFlags = ''BITMAP_DEFINES=-DBITMAPDIR=\"/no-such-path\"'';
  });

  libXrandr = super.libXrandr.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = [self.libXrender];
  });

  libSM = super.libSM.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
    propagatedBuildInputs = [ self.libICE ];
  });

  libXrender = super.libXrender.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = [ self.renderproto ];
  });

  libXres = super.libXres.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "devdoc" ];
  });

  libXv = super.libXv.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "devdoc" ];
  });

  libXvMC = super.libXvMC.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
    buildInputs = attrs.buildInputs ++ [self.renderproto];
  });

  libXp = super.libXp.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXpm = super.libXpm.overrideAttrs (attrs: {
    name = "libXpm-3.5.12";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXpm-3.5.12.tar.bz2;
      sha256 = "1v5xaiw4zlhxspvx76y3hq4wpxv7mpj6parqnwdqvpj8vbinsspx";
    };
    outputs = [ "bin" "dev" "out" ]; # tiny man in $bin
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
  });

  libXpresent = super.libXpresent.overrideAttrs (attrs: {
    buildInputs = with self; attrs.buildInputs ++ [ libXext libXfixes libXrandr ];
  });

  libxkbfile = super.libxkbfile.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # mainly to avoid propagation
  });

  libxshmfence = super.libxshmfence.overrideAttrs (attrs: {
    name = "libxshmfence-1.3";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libxshmfence-1.3.tar.bz2;
      sha256 = "1ir0j92mnd1nk37mrv9bz5swnccqldicgszvfsh62jd14q6k115q";
    };
    outputs = [ "out" "dev" ]; # mainly to avoid propagation
  });

  libpciaccess = super.libpciaccess.overrideAttrs (attrs: {
    meta = attrs.meta // { platforms = stdenv.lib.platforms.linux; };
  });

  setxkbmap = super.setxkbmap.overrideAttrs (attrs: {
    postInstall =
      ''
        mkdir -p $out/share
        ln -sfn ${self.xkeyboardconfig}/etc/X11 $out/share/X11
      '';
  });

  utilmacros = super.utilmacros.overrideAttrs (attrs: { # not needed for releases, we propagate the needed tools
    propagatedBuildInputs = [ automake autoconf libtool ];
  });

  x11perf = super.x11perf.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ freetype fontconfig ];
  });

  xcbutil = super.xcbutil.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  xcbutilcursor = super.xcbutilcursor.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    meta = attrs.meta // { maintainers = [ stdenv.lib.maintainers.lovek323 ]; };
  });

  xcbutilimage = super.xcbutilimage.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  });

  xcbutilkeysyms = super.xcbutilkeysyms.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  });

  xcbutilrenderutil = super.xcbutilrenderutil.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  });

  xcbutilwm = super.xcbutilwm.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  });

  xf86inputevdev = super.xf86inputevdev.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # to get rid of xorgserver.dev; man is tiny
    preBuild = "sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c";
    installFlags = "sdkdir=\${out}/include/xorg";
    buildInputs = attrs.buildInputs ++ [ mtdev libevdev ];
  });

  xf86inputmouse = super.xf86inputmouse.overrideAttrs (attrs: {
    installFlags = "sdkdir=\${out}/include/xorg";
  });

  xf86inputjoystick = super.xf86inputjoystick.overrideAttrs (attrs: {
    installFlags = "sdkdir=\${out}/include/xorg";
  });

  xf86inputlibinput = super.xf86inputlibinput.overrideAttrs (attrs: rec {
    name = "xf86-input-libinput-0.28.0";
    src = fetchurl {
      url = "mirror://xorg/individual/driver/${name}.tar.bz2";
      sha256 = "189h8vl0005yizwrs4d0sng6j8lwkd3xi1zwqg8qavn2bw34v691";
    };
    outputs = [ "out" "dev" ];
    buildInputs = attrs.buildInputs ++ [ libinput ];
    installFlags = "sdkdir=\${dev}/include/xorg";
  });

  xf86inputsynaptics = super.xf86inputsynaptics.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # *.pc pulls xorgserver.dev
    buildInputs = attrs.buildInputs ++ [mtdev libevdev];
    installFlags = "sdkdir=\${out}/include/xorg configdir=\${out}/share/X11/xorg.conf.d";
  });

  xf86inputvmmouse = super.xf86inputvmmouse.overrideAttrs (attrs: {
    configureFlags = [
      "--sysconfdir=$(out)/etc"
      "--with-xorg-conf-dir=$(out)/share/X11/xorg.conf.d"
      "--with-udev-rules-dir=$(out)/lib/udev/rules.d"
    ];

    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  });

  # Obsolete drivers that don't compile anymore.
  xf86videoark     = super.xf86videoark.overrideAttrs     (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videogeode   = super.xf86videogeode.overrideAttrs   (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videoglide   = super.xf86videoglide.overrideAttrs   (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videoi128    = super.xf86videoi128.overrideAttrs    (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videonewport = super.xf86videonewport.overrideAttrs (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videotga     = super.xf86videotga.overrideAttrs     (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videov4l     = super.xf86videov4l.overrideAttrs     (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videovoodoo  = super.xf86videovoodoo.overrideAttrs  (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videowsfb    = super.xf86videowsfb.overrideAttrs    (attrs: { meta = attrs.meta // { broken = true; }; });

  xf86videoamdgpu = super.xf86videoamdgpu.overrideAttrs (attrs: {
    configureFlags = [ "--with-xorg-conf-dir=$(out)/share/X11/xorg.conf.d" ];
  });

  xf86videoati = super.xf86videoati.overrideAttrs (attrs: {
    NIX_CFLAGS_COMPILE = "-I${self.xorgserver.dev or self.xorgserver}/include/xorg";
  });

  xf86videovmware = super.xf86videovmware.overrideAttrs (attrs: {
    buildInputs =  attrs.buildInputs ++ [ mesa_noglu llvm_6 ]; # for libxatracker
    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  });

  xf86videoqxl = super.xf86videoqxl.overrideAttrs (attrs: {
    buildInputs =  attrs.buildInputs ++ [ spice-protocol ];
  });

  xf86videosiliconmotion = super.xf86videosiliconmotion.overrideAttrs (attrs: {
    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  });

  xdriinfo = super.xdriinfo.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [libGL];
  });

  xvinfo = super.xvinfo.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [self.libXext];
  });

  xkbcomp = super.xkbcomp.overrideAttrs (attrs: {
    configureFlags = [ "--with-xkb-config-root=${self.xkeyboardconfig}/share/X11/xkb" ];
  });

  xkeyboardconfig = super.xkeyboardconfig.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [intltool];

    #TODO: resurrect patches for US_intl?
    patches = [ ./xkeyboard-config-eo.patch ];

    configureFlags = [ "--with-xkb-rules-symlink=xorg" ];

    # 1: compatibility for X11/xkb location
    # 2: I think pkgconfig/ is supposed to be in /lib/
    postInstall = ''
      ln -s share "$out/etc"
      mkdir -p "$out/lib" && ln -s ../share/pkgconfig "$out/lib/"
    '';
  });

  xlsfonts = super.xlsfonts.overrideAttrs (attrs: {
    meta = attrs.meta // { license = lib.licenses.mit; };
  });

  xorgserver = with self; super.xorgserver.overrideAttrs (attrs_passed:
    # exchange attrs if abiCompat is set
    let
      version = (builtins.parseDrvName attrs_passed.name).version;
      attrs =
        if (abiCompat == null || lib.hasPrefix abiCompat version) then attrs_passed
        else if (abiCompat == "1.17") then {
          name = "xorg-server-1.17.4";
          builder = ./builder.sh;
          src = fetchurl {
            url = mirror://xorg/individual/xserver/xorg-server-1.17.4.tar.bz2;
            sha256 = "0mv4ilpqi5hpg182mzqn766frhi6rw48aba3xfbaj4m82v0lajqc";
          };
          nativeBuildInputs = [ pkgconfig ];
          buildInputs = [ dri2proto dri3proto renderproto libdrm openssl libX11 libXau libXaw libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt ];
          meta.platforms = stdenv.lib.platforms.unix;
        } else if (abiCompat == "1.18") then {
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
        } else throw "unsupported xorg abiCompat ${abiCompat} for ${attrs_passed.name}";

    in attrs //
    (let
      version = (builtins.parseDrvName attrs.name).version;
      commonBuildInputs = attrs.buildInputs ++ [ xtrans ];
      commonPropagatedBuildInputs = [
        zlib libGL libGLU dbus
        xf86bigfontproto glproto xf86driproto
        compositeproto scrnsaverproto resourceproto
        xf86dgaproto
        dmxproto /*libdmx not used*/ xf86vidmodeproto
        recordproto libXext pixman libXfont libxshmfence libunwind
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
        buildInputs = commonBuildInputs ++ [ libdrm mesa_noglu ];
        propagatedBuildInputs = [ libpciaccess epoxy ] ++ commonPropagatedBuildInputs ++ lib.optionals stdenv.isLinux [
          udev
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
          "--with-xkb-bin-directory=${self.xkbcomp}/bin"
          "--with-xkb-path=${self.xkeyboardconfig}/share/X11/xkb"
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
        nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook self.utilmacros self.fontutil ];
        buildInputs = commonBuildInputs ++ [
          bootstrap_cmds automake autoconf
          apple_sdk.libs.Xplugin
          apple_sdk.frameworks.Carbon
          apple_sdk.frameworks.Cocoa
        ];
        propagatedBuildInputs = commonPropagatedBuildInputs ++ [
          libAppleWM applewmproto
        ];

        # XQuartz patchset
        patches = [
          (fetchpatch {
            url = "https://github.com/XQuartz/xorg-server/commit/e88fd6d785d5be477d5598e70d105ffb804771aa.patch";
            sha256 = "1q0a30m1qj6ai924afz490xhack7rg4q3iig2gxsjjh98snikr1k";
            name = "use-cppflags-not-cflags.patch";
          })
          (fetchpatch {
            url = "https://github.com/XQuartz/xorg-server/commit/75ee9649bcfe937ac08e03e82fd45d9e18110ef4.patch";
            sha256 = "1vlfylm011y00j8mig9zy6gk9bw2b4ilw2qlsc6la49zi3k0i9fg";
            name = "use-old-mitrapezoids-and-mitriangles-routines.patch";
          })
          (fetchpatch {
            url = "https://github.com/XQuartz/xorg-server/commit/c58f47415be79a6564a9b1b2a62c2bf866141e73.patch";
            sha256 = "19sisqzw8x2ml4lfrwfvavc2jfyq2bj5xcf83z89jdxg8g1gdd1i";
            name = "revert-fb-changes-1.patch";
          })
          (fetchpatch {
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
          substituteInPlace hw/xquartz/pbproxy/Makefile.in --replace -F/System -F${apple_sdk.frameworks.ApplicationServices}
        '';
        postInstall = ''
          rm -fr $out/share/X11/xkb/compiled

          cp -rT ${darwinOtherX}/bin $out/bin
          rm -f $out/bin/X
          ln -s Xquartz $out/bin/X

          cp ${darwinOtherX}/share/man -rT $out/share/man
        '' ;
        passthru.version = version;
      }));

  lndir = super.lndir.overrideAttrs (attrs: {
    preConfigure = ''
      substituteInPlace lndir.c \
        --replace 'n_dirs--;' ""
    '';
  });

  twm = super.twm.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [bison flex];
  });

  xauth = super.xauth.overrideAttrs (attrs: {
    doCheck = false; # fails
  });

  xcursorthemes = super.xcursorthemes.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [self.xcursorgen];
    configureFlags = [ "--with-cursordir=$(out)/share/icons" ];
  });

  xinit = (super.xinit.override {
    stdenv = if isDarwin then clangStdenv else stdenv;
  }).overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ lib.optional isDarwin bootstrap_cmds;
    configureFlags = [
      "--with-xserver=${self.xorgserver.out}/bin/X"
    ] ++ lib.optionals isDarwin [
      "--with-bundle-id-prefix=org.nixos.xquartz"
      "--with-launchdaemons-dir=\${out}/LaunchDaemons"
      "--with-launchagents-dir=\${out}/LaunchAgents"
    ];
    propagatedBuildInputs = [ self.xauth ]
                         ++ lib.optionals isDarwin [ self.libX11 self.xproto ];
    prePatch = ''
      sed -i 's|^defaultserverargs="|&-logfile \"$HOME/.xorg.log\"|p' startx.cpp
    '';
  });

  xf86videointel = super.xf86videointel.overrideAttrs (attrs: {
    # the update script only works with released tarballs :-/
    name = "xf86-video-intel-2017-10-19";
    src = fetchurl {
      url = "http://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/"
          + "4798e18b2b2c8b0a05dc967e6140fd9962bc1a73.tar.gz";
      sha256 = "1zpgbibfpdassswfj68zwhhfpvd2p80rpxw92bis6lv81ssknwby";
    };
    buildInputs = attrs.buildInputs ++ [self.libXfixes self.libXScrnSaver self.pixman];
    nativeBuildInputs = attrs.nativeBuildInputs ++ [autoreconfHook self.utilmacros];
    configureFlags = [ "--with-default-dri=3" "--enable-tools" ];

    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  });

  xf86videoxgi = super.xf86videoxgi.overrideAttrs (attrs: {
    patches = [
      # fixes invalid open mode
      # https://cgit.freedesktop.org/xorg/driver/xf86-video-xgi/commit/?id=bd94c475035739b42294477cff108e0c5f15ef67
      (fetchpatch {
        url = "https://cgit.freedesktop.org/xorg/driver/xf86-video-xgi/patch/?id=bd94c475035739b42294477cff108e0c5f15ef67";
        sha256 = "0myfry07655adhrpypa9rqigd6rfx57pqagcwibxw7ab3wjay9f6";
      })
      (fetchpatch {
        url = "https://cgit.freedesktop.org/xorg/driver/xf86-video-xgi/patch/?id=78d1138dd6e214a200ca66fa9e439ee3c9270ec8";
        sha256 = "0z3643afgrync280zrp531ija0hqxc5mrwjif9nh9lcnzgnz2d6d";
      })
    ];
  });

  xorgcffiles = super.xorgcffiles.overrideAttrs (attrs: {
    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace $out/lib/X11/config/darwin.cf --replace "/usr/bin/" ""
    '';
  });

  xwd = super.xwd.overrideAttrs (attrs: {
    buildInputs = with self; attrs.buildInputs ++ [libXt libxkbfile];
  });

  kbproto = super.kbproto.overrideAttrs (attrs: {
    outputs = [ "out" "doc" ];
  });

  xextproto = super.xextproto.overrideAttrs (attrs: {
    outputs = [ "out" "doc" ];
  });

  xproto = super.xproto.overrideAttrs (attrs: {
    outputs = [ "out" "doc" ];
  });

  xrdb = super.xrdb.overrideAttrs (attrs: {
    configureFlags = [ "--with-cpp=${mcpp}/bin/mcpp" ];
  });

  sessreg = super.sessreg.overrideAttrs (attrs: {
    preBuild = "sed -i 's|gcc -E|gcc -E -P|' man/Makefile";
  });

  xrandr = super.xrandr.overrideAttrs (attrs: {
    postInstall = ''
      rm $out/bin/xkeystone
    '';
  });
}
