{ abiCompat ? null,
  callPackage,
  lib, stdenv, makeWrapper, fetchurl, fetchpatch, fetchFromGitLab, buildPackages,
  automake, autoconf, libiconv, libtool, intltool,
  freetype, tradcpp, fontconfig, meson, ninja, ed, fontforge,
  libGL, spice-protocol, zlib, libGLU, dbus, libunwind, libdrm, netbsd,
  ncompress,
  mesa, udev, bootstrap_cmds, bison, flex, clangStdenv, autoreconfHook,
  mcpp, libepoxy, openssl, pkg-config, llvm, libxslt, libxcrypt,
  ApplicationServices, Carbon, Cocoa, Xplugin,
  xorg
}:

let
  inherit (stdenv) isDarwin;

  malloc0ReturnsNullCrossFlag = lib.optional
    (stdenv.hostPlatform != stdenv.buildPlatform)
    "--enable-malloc0returnsnull";

  brokenOnDarwin = pkg: pkg.overrideAttrs (attrs: {
    meta = attrs.meta // { broken = isDarwin; };
  });
in
self: super:
{
  wrapWithXFileSearchPathHook = callPackage ({ makeBinaryWrapper, makeSetupHook, writeScript }: makeSetupHook {
      name = "wrapWithXFileSearchPathHook";
      propagatedBuildInputs = [ makeBinaryWrapper ];
    } (writeScript "wrapWithXFileSearchPathHook.sh" ''
      wrapWithXFileSearchPath() {
        paths=(
          "$out/share/X11/%T/%N"
          "$out/include/X11/%T/%N"
          "${xorg.xbitmaps}/include/X11/%T/%N"
        )
        for exe in $out/bin/*; do
          wrapProgram "$exe" \
            --suffix XFILESEARCHPATH : $(IFS=:; echo "''${paths[*]}")
        done
      }
      postInstallHooks+=(wrapWithXFileSearchPath)
  '')) {};

  bdftopcf = super.bdftopcf.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ xorg.xorgproto ];
  });

  editres = super.editres.overrideAttrs (attrs: {
    hardeningDisable = [ "format" ];
  });

  fontmiscmisc = super.fontmiscmisc.overrideAttrs (attrs: {
    postInstall =
      ''
        ALIASFILE=${xorg.fontalias}/share/fonts/X11/misc/fonts.alias
        test -f $ALIASFILE
        cp $ALIASFILE $out/lib/X11/fonts/misc/fonts.alias
      '';
  });

  fonttosfnt = super.fonttosfnt.overrideAttrs (attrs: {
    meta = attrs.meta // { license = lib.licenses.mit; };
  });

  imake = super.imake.overrideAttrs (attrs: {
    inherit (xorg) xorgcffiles;
    x11BuildHook = ./imake.sh;
    patches = [./imake.patch ./imake-cc-wrapper-uberhack.patch];
    setupHook = ./imake-setup-hook.sh;
    CFLAGS = "-DIMAKE_COMPILETIME_CPP='\"${if stdenv.isDarwin
      then "${tradcpp}/bin/cpp"
      else "gcc"}\"'";

    configureFlags = attrs.configureFlags or [] ++ [ "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp" ];

    inherit tradcpp;
  });

  mkfontdir = xorg.mkfontscale;

  libxcb = super.libxcb.overrideAttrs (attrs: {
    configureFlags = [ "--enable-xkb" "--enable-xinput" ]
      ++ lib.optional stdenv.hostPlatform.isStatic "--disable-shared";
    outputs = [ "out" "dev" "man" "doc" ];
  });

  libX11 = super.libX11.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "man" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    depsBuildBuild = [
      buildPackages.stdenv.cc
    ] ++ lib.optionals stdenv.hostPlatform.isStatic [
      (xorg.buildPackages.stdenv.cc.libc.static or null)
    ];
    preConfigure = ''
      sed 's,^as_dummy.*,as_dummy="\$PATH",' -i configure
    '';
    postInstall = ''
      # Remove useless DocBook XML files.
      rm -rf $out/share/doc
    '';
    CPP = lib.optionalString stdenv.isDarwin "clang -E -";
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.xorgproto ];
  });

  libAppleWM = super.libAppleWM.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ ApplicationServices ];
    preConfigure = ''
      substituteInPlace src/Makefile.in --replace -F/System -F${ApplicationServices}
    '';
  });

  libXau = super.libXau.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.xorgproto ];
  });

  libXdmcp = super.libXdmcp.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
  });

  libXfont = super.libXfont.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ freetype ]; # propagate link reqs. like bzip2
    # prevents "misaligned_stack_error_entering_dyld_stub_binder"
    configureFlags = lib.optional isDarwin "CFLAGS=-O0";
  });

  libXxf86vm = super.libXxf86vm.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });
  libXxf86dga = super.libXxf86dga.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });
  libXxf86misc = super.libXxf86misc.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });
  libdmx = super.libdmx.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });
  libFS = super.libFS.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });
  libWindowsWM = super.libWindowsWM.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });
  xdpyinfo = super.xdpyinfo.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    preConfigure = attrs.preConfigure or ""
    # missing transitive dependencies
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lXau -lXdmcp"
    '';
  });

  xdm = super.xdm.overrideAttrs (attrs: {
    patches = (attrs.patches or []) ++ [ ./xdm-fix-header-inclusion.patch ];
    buildInputs = attrs.buildInputs ++ [ libxcrypt ];
    configureFlags = attrs.configureFlags or [] ++ [
      "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp"
    ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform)
      # checking for /dev/urandom... configure: error: cannot check for file existence when cross compiling
      [ "ac_cv_file__dev_urandom=true" "ac_cv_file__dev_random=true" ];
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
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.libSM ];
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    CPP = if stdenv.isDarwin then "clang -E -" else "${stdenv.cc.targetPrefix}cc -E -";
    outputDoc = "devdoc";
    outputs = [ "out" "dev" "devdoc" ];
  });

  luit = super.luit.overrideAttrs (attrs: {
    # See https://bugs.freedesktop.org/show_bug.cgi?id=47792
    # Once the bug is fixed upstream, this can be removed.
    configureFlags = [ "--disable-selective-werror" ];

    buildInputs = attrs.buildInputs ++ [libiconv];
  });

  libICE = super.libICE.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
  });

  libXcomposite = super.libXcomposite.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.libXfixes ];
  });

  libXaw = super.libXaw.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "devdoc" ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.libXmu ];
  });

  libXcursor = super.libXcursor.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXdamage = super.libXdamage.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXft = super.libXft.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.libXrender freetype fontconfig ];
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
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.xorgproto xorg.libXau ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });

  libXfixes = super.libXfixes.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXi = super.libXi.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "man" "doc" ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.libXfixes xorg.libXext ];
    configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "xorg_cv_malloc0_returns_null=no"
    ] ++ lib.optional stdenv.hostPlatform.isStatic "--disable-shared";
  });

  libXinerama = super.libXinerama.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });

  libXmu = super.libXmu.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
    buildFlags = [ "BITMAP_DEFINES='-DBITMAPDIR=\"/no-such-path\"'" ];
  });

  libXrandr = super.libXrandr.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.libXrender ];
  });

  libSM = super.libSM.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.libICE ];
  });

  libXrender = super.libXrender.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.xorgproto ];
  });

  libXres = super.libXres.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "devdoc" ];
    buildInputs = with xorg; attrs.buildInputs ++ [ utilmacros ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });

  libXScrnSaver = super.libXScrnSaver.overrideAttrs (attrs: {
    buildInputs = with xorg; attrs.buildInputs ++ [ utilmacros ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });

  libXv = super.libXv.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "devdoc" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
  });

  libXvMC = super.libXvMC.overrideAttrs (attrs: {
    outputs = [ "out" "dev" "doc" ];
    configureFlags = attrs.configureFlags or []
      ++ malloc0ReturnsNullCrossFlag;
    buildInputs = attrs.buildInputs ++ [xorg.xorgproto];
  });

  libXp = super.libXp.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  libXpm = super.libXpm.overrideAttrs (attrs: {
    outputs = [ "bin" "dev" "out" ]; # tiny man in $bin
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
    XPM_PATH_COMPRESS = lib.makeBinPath [ ncompress ];
  });

  libXpresent = super.libXpresent.overrideAttrs (attrs: {
    buildInputs = with xorg; attrs.buildInputs ++ [ libXext libXfixes libXrandr ];
  });

  libxkbfile = super.libxkbfile.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # mainly to avoid propagation
  });

  libxshmfence = super.libxshmfence.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # mainly to avoid propagation
  });

  libpciaccess = super.libpciaccess.overrideAttrs (attrs: {
    buildInputs = lib.optionals stdenv.hostPlatform.isNetBSD (with netbsd; [ libarch libpci ]);

    meta = attrs.meta // {
      # https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/blob/master/configure.ac#L108-114
      platforms = lib.fold (os: ps: ps ++ lib.platforms.${os}) []
        [ "cygwin" "freebsd" "linux" "netbsd" "openbsd" "illumos" ];
    };
  });

  setxkbmap = super.setxkbmap.overrideAttrs (attrs: {
    postInstall =
      ''
        mkdir -p $out/share/man/man7
        ln -sfn ${xorg.xkeyboardconfig}/etc/X11 $out/share/X11
        ln -sfn ${xorg.xkeyboardconfig}/share/man/man7/xkeyboard-config.7.gz $out/share/man/man7
      '';
  });

  utilmacros = super.utilmacros.overrideAttrs (attrs: { # not needed for releases, we propagate the needed tools
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ automake autoconf libtool ];
  });

  x11perf = super.x11perf.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ freetype fontconfig ];
  });

  xcbutil = super.xcbutil.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
  });

  xcbutilerrors = super.xcbutilerrors.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # mainly to get rid of propagating others
  });

  xcbutilcursor = super.xcbutilcursor.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    meta = attrs.meta // { maintainers = [ lib.maintainers.lovek323 ]; };
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
    configureFlags = [
      "--with-sdkdir=${placeholder "dev"}/include/xorg"
    ];
  });

  xf86inputmouse = super.xf86inputmouse.overrideAttrs (attrs: {
    configureFlags = [
      "--with-sdkdir=${placeholder "out"}/include/xorg"
    ];
    meta = attrs.meta // {
      broken = isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputmouse.x86_64-darwin
    };
  });

  xf86inputjoystick = super.xf86inputjoystick.overrideAttrs (attrs: {
    configureFlags = [
      "--with-sdkdir=${placeholder "out"}/include/xorg"
    ];
    meta = attrs.meta // {
      broken = isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputjoystick.x86_64-darwin
    };
  });

  xf86inputkeyboard = brokenOnDarwin super.xf86inputkeyboard; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputkeyboard.x86_64-darwin

  xf86inputlibinput = super.xf86inputlibinput.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ];
    configureFlags = [
      "--with-sdkdir=${placeholder "dev"}/include/xorg"
    ];
  });

  xf86inputsynaptics = super.xf86inputsynaptics.overrideAttrs (attrs: {
    outputs = [ "out" "dev" ]; # *.pc pulls xorgserver.dev
    configureFlags = [
      "--with-sdkdir=${placeholder "dev"}/include/xorg"
      "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
    ];
  });

  xf86inputvmmouse = super.xf86inputvmmouse.overrideAttrs (attrs: {
    configureFlags = [
      "--sysconfdir=${placeholder "out"}/etc"
      "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
      "--with-udev-rules-dir=${placeholder "out"}/lib/udev/rules.d"
    ];

    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  });

  xf86inputvoid = brokenOnDarwin super.xf86inputvoid; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputvoid.x86_64-darwin
  xf86videodummy = brokenOnDarwin super.xf86videodummy; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videodummy.x86_64-darwin

  # Obsolete drivers that don't compile anymore.
  xf86videoark     = super.xf86videoark.overrideAttrs     (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videogeode   = super.xf86videogeode.overrideAttrs   (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videoglide   = super.xf86videoglide.overrideAttrs   (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videoi128    = super.xf86videoi128.overrideAttrs    (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videonewport = super.xf86videonewport.overrideAttrs (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videos3virge = super.xf86videos3virge.overrideAttrs (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videosavage  = super.xf86videosavage.overrideAttrs  (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videotga     = super.xf86videotga.overrideAttrs     (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videov4l     = super.xf86videov4l.overrideAttrs     (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videovoodoo  = super.xf86videovoodoo.overrideAttrs  (attrs: { meta = attrs.meta // { broken = true; }; });
  xf86videowsfb    = super.xf86videowsfb.overrideAttrs    (attrs: { meta = attrs.meta // { broken = true; }; });

  xf86videoomap    = super.xf86videoomap.overrideAttrs (attrs: {
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=format-overflow" ];
  });

  xf86videoamdgpu = super.xf86videoamdgpu.overrideAttrs (attrs: {
    configureFlags = [ "--with-xorg-conf-dir=$(out)/share/X11/xorg.conf.d" ];
  });

  xf86videoati = super.xf86videoati.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook ];
    buildInputs =  attrs.buildInputs ++ [ xorg.utilmacros ];
    patches = [
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-ati/-/commit/e0511968d04b42abf11bc0ffb387f143582bc144.patch";
        sha256 = "sha256-79nqKuJRgMYXDEMB8IWxdmbxtI/m+Oca1wSLYeGMuEk=";
      })
    ];
  });

  xf86videonouveau = super.xf86videonouveau.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook ];
    buildInputs =  attrs.buildInputs ++ [ xorg.utilmacros ];
  });

  xf86videoglint = super.xf86videoglint.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook ];
    buildInputs =  attrs.buildInputs ++ [ xorg.utilmacros ];
    # https://gitlab.freedesktop.org/xorg/driver/xf86-video-glint/-/issues/1
    meta = attrs.meta // { broken = true; };
  });

  xf86videosuncg6 = super.xf86videosuncg6.overrideAttrs (attrs: {
    meta = attrs.meta // { broken = isDarwin; }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosuncg6.x86_64-darwin
  });

  xf86videosunffb = super.xf86videosunffb.overrideAttrs (attrs: {
    meta = attrs.meta // { broken = isDarwin; }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosunffb.x86_64-darwin
  });

  xf86videosunleo = super.xf86videosunleo.overrideAttrs (attrs: {
    meta = attrs.meta // { broken = isDarwin; }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosunleo.x86_64-darwin
  });

  xf86videovmware = super.xf86videovmware.overrideAttrs (attrs: {
    buildInputs =  attrs.buildInputs ++ [ mesa mesa.driversdev llvm ]; # for libxatracker
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=address" ]; # gcc12
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
    buildInputs = attrs.buildInputs ++ [xorg.libXext];
  });

  xkbcomp = super.xkbcomp.overrideAttrs (attrs: {
    configureFlags = [ "--with-xkb-config-root=${xorg.xkeyboardconfig}/share/X11/xkb" ];
  });

  xkeyboardconfig = super.xkeyboardconfig.overrideAttrs (attrs: {
    prePatch = "patchShebangs rules/merge.py";
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ intltool libxslt ];
    configureFlags = [ "--with-xkb-rules-symlink=xorg" ];

    # 1: compatibility for X11/xkb location
    # 2: I think pkg-config/ is supposed to be in /lib/
    postInstall = ''
      ln -s share "$out/etc"
      mkdir -p "$out/lib" && ln -s ../share/pkgconfig "$out/lib/"
    '';
  });

  # xkeyboardconfig variant extensible with custom layouts.
  # See nixos/modules/services/x11/extra-layouts.nix
  xkeyboardconfig_custom = { layouts ? { } }:
  let
    patchIn = name: layout:
    with layout;
    with lib;
    ''
        # install layout files
        ${optionalString (compatFile   != null) "cp '${compatFile}'   'compat/${name}'"}
        ${optionalString (geometryFile != null) "cp '${geometryFile}' 'geometry/${name}'"}
        ${optionalString (keycodesFile != null) "cp '${keycodesFile}' 'keycodes/${name}'"}
        ${optionalString (symbolsFile  != null) "cp '${symbolsFile}'  'symbols/${name}'"}
        ${optionalString (typesFile    != null) "cp '${typesFile}'    'types/${name}'"}

        # patch makefiles
        for type in compat geometry keycodes symbols types; do
          if ! test -f "$type/${name}"; then
            continue
          fi
          test "$type" = geometry && type_name=geom || type_name=$type
          ${ed}/bin/ed -v $type/Makefile.am <<EOF
        /''${type_name}_DATA =
        a
        ${name} \\
        .
        w
        EOF
          ${ed}/bin/ed -v $type/Makefile.in <<EOF
        /''${type_name}_DATA =
        a
        ${name} \\
        .
        w
        EOF
        done

        # add model description
        ${ed}/bin/ed -v rules/base.xml <<EOF
        /<\/modelList>
        -
        a
        <model>
          <configItem>
            <name>${name}</name>
            <description>${layout.description}</description>
            <vendor>${layout.description}</vendor>
          </configItem>
        </model>
        .
        w
        EOF

        # add layout description
        ${ed}/bin/ed -v rules/base.xml <<EOF
        /<\/layoutList>
        -
        a
        <layout>
          <configItem>
            <name>${name}</name>
            <shortDescription>${name}</shortDescription>
            <description>${layout.description}</description>
            <languageList>
              ${concatMapStrings (lang: "<iso639Id>${lang}</iso639Id>\n") layout.languages}
            </languageList>
          </configItem>
          <variantList/>
        </layout>
        .
        w
        EOF
    '';
  in
    xorg.xkeyboardconfig.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ automake ];
      postPatch   = with lib; concatStrings (mapAttrsToList patchIn layouts);
    });

  xlsfonts = super.xlsfonts.overrideAttrs (attrs: {
    meta = attrs.meta // { license = lib.licenses.mit; };
  });

  xorgproto = super.xorgproto.overrideAttrs (attrs: {
    buildInputs = [];
    propagatedBuildInputs = [];
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ meson ninja ];
    # adds support for printproto needed for libXp
    mesonFlags = [ "-Dlegacy=true" ];
  });

  xorgserver = with xorg; super.xorgserver.overrideAttrs (attrs_passed:
    # exchange attrs if abiCompat is set
    let
      version = lib.getVersion attrs_passed;
      attrs =
        if (abiCompat == null || lib.hasPrefix abiCompat version) then
          attrs_passed // {
            buildInputs = attrs_passed.buildInputs ++
              lib.optional (libdrm != null) libdrm.dev;
            postPatch = ''
              for i in dri3/*.c
              do
                sed -i -e "s|#include <drm_fourcc.h>|#include <libdrm/drm_fourcc.h>|" $i
              done
            '';
          }
        else throw "unsupported xorg abiCompat ${abiCompat} for ${attrs_passed.name}";

    in attrs //
    (let
      version = lib.getVersion attrs;
      commonBuildInputs = attrs.buildInputs ++ [ xtrans libxcvt ];
      commonPropagatedBuildInputs = [
        dbus libGL libGLU libXext libXfont libXfont2 libepoxy libunwind
        libxshmfence pixman xorgproto zlib
      ];
      # XQuartz requires two compilations: the first to get X / XQuartz,
      # and the second to get Xvfb, Xnest, etc.
      darwinOtherX = xorgserver.overrideAttrs (oldAttrs: {
        configureFlags = oldAttrs.configureFlags ++ [
          "--disable-xquartz"
          "--enable-xorg"
          "--enable-xvfb"
          "--enable-xnest"
          "--enable-kdrive"
        ];
        postInstall = ":"; # prevent infinite recursion
      });

      fpgit = commit: sha256: name: fetchpatch (
        {
          url = "https://gitlab.freedesktop.org/xorg/xserver/-/commit/${commit}.diff";
          inherit sha256;
        } // lib.optionalAttrs (name != null) {
            name = name + ".patch";
          }
      );
    in
      if (!isDarwin)
      then {
        outputs = [ "out" "dev" ];
        patches = [
          # The build process tries to create the specified logdir when building.
          #
          # We set it to /var/log which can't be touched from inside the sandbox causing the build to hard-fail
          ./dont-create-logdir-during-build.patch
        ];
        buildInputs = commonBuildInputs ++ [ libdrm mesa ];
        propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ libpciaccess ] ++ commonPropagatedBuildInputs ++ lib.optionals stdenv.isLinux [
          udev
        ];
        depsBuildBuild = [ buildPackages.stdenv.cc ];
        prePatch = lib.optionalString stdenv.hostPlatform.isMusl ''
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
          "--with-log-dir=/var/log"
          "--enable-glamor"
          "--with-os-name=Nix" # r13y, embeds the build machine's kernel version otherwise
        ] ++ lib.optionals stdenv.hostPlatform.isMusl [
          "--disable-tls"
        ];

        env.NIX_CFLAGS_COMPILE = toString [
          # Needed with GCC 12
          "-Wno-error=array-bounds"
        ];

        postInstall = ''
          rm -fr $out/share/X11/xkb/compiled # otherwise X will try to write in it
          ( # assert() keeps runtime reference xorgserver-dev in xf86-video-intel and others
            cd "$dev"
            for f in include/xorg/*.h; do
              sed "1i#line 1 \"${attrs.pname}-${attrs.version}/$f\"" -i "$f"
            done
          )
        '';
        passthru.version = version; # needed by virtualbox guest additions
      } else {
        nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook bootstrap_cmds xorg.utilmacros xorg.fontutil ];
        buildInputs = commonBuildInputs ++ [
          bootstrap_cmds automake autoconf
          Xplugin Carbon Cocoa
        ];
        propagatedBuildInputs = commonPropagatedBuildInputs ++ [
          libAppleWM xorgproto
        ];

        patches = [
          # XQuartz patchset
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
          "--disable-glamor"
          "--with-default-font-path="
          "--with-apple-application-name=XQuartz"
          "--with-apple-applications-dir=\${out}/Applications"
          "--with-bundle-id-prefix=org.nixos.xquartz"
          "--with-sha1=CommonCrypto"
          "--without-dtrace" # requires Command Line Tools for Xcode
        ];
        preConfigure = ''
          mkdir -p $out/Applications
          export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error"
          substituteInPlace hw/xquartz/pbproxy/Makefile.in --replace -F/System -F${ApplicationServices}
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
    buildInputs = [];
    preConfigure = ''
      export XPROTO_CFLAGS=" "
      export XPROTO_LIBS=" "
      substituteInPlace lndir.c \
        --replace '<X11/Xos.h>' '<string.h>' \
        --replace '<X11/Xfuncproto.h>' '<unistd.h>' \
        --replace '_X_ATTRIBUTE_PRINTF(1,2)' '__attribute__((__format__(__printf__,1,2)))' \
        --replace '_X_ATTRIBUTE_PRINTF(2,3)' '__attribute__((__format__(__printf__,2,3)))' \
        --replace '_X_NORETURN' '__attribute__((noreturn))' \
        --replace 'n_dirs--;' ""
    '';
  });

  twm = super.twm.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [bison flex];
  });

  xauth = super.xauth.overrideAttrs (attrs: {
    doCheck = false; # fails
    preConfigure = attrs.preConfigure or ""
    # missing transitive dependencies
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lxcb -lXau -lXdmcp"
    '';
  });

  xcursorthemes = super.xcursorthemes.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ xorg.xcursorgen ];
    buildInputs = attrs.buildInputs ++ [ xorg.xorgproto ];
    configureFlags = [ "--with-cursordir=$(out)/share/icons" ];
  });

  xinit = (super.xinit.override {
    stdenv = if isDarwin then clangStdenv else stdenv;
  }).overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ lib.optional isDarwin bootstrap_cmds;
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    configureFlags = [
      "--with-xserver=${xorg.xorgserver.out}/bin/X"
    ] ++ lib.optionals isDarwin [
      "--with-bundle-id-prefix=org.nixos.xquartz"
      "--with-launchdaemons-dir=\${out}/LaunchDaemons"
      "--with-launchagents-dir=\${out}/LaunchAgents"
    ];
    patches = [
      # don't unset DBUS_SESSION_BUS_ADDRESS in startx
      (fetchpatch {
        name = "dont-unset-DBUS_SESSION_BUS_ADDRESS.patch";
        url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/40f3ac0a31336d871c76065270d3f10e922d06f3/trunk/fs46369.patch";
        sha256 = "18kb88i3s9nbq2jxl7l2hyj6p56c993hivk8mzxg811iqbbawkp7";
      })
    ];
    postPatch = ''
      # Avoid replacement of word-looking cpp's builtin macros in Nix's cross-compiled paths
      substituteInPlace Makefile.in --replace "PROGCPPDEFS =" "PROGCPPDEFS = -Dlinux=linux -Dunix=unix"
    '';
    propagatedBuildInputs = attrs.propagatedBuildInputs or [] ++ [ xorg.xauth ]
                         ++ lib.optionals isDarwin [ xorg.libX11 xorg.xorgproto ];
    postFixup = ''
      substituteInPlace $out/bin/startx \
        --replace $out/etc/X11/xinit/xserverrc /etc/X11/xinit/xserverrc \
        --replace $out/etc/X11/xinit/xinitrc /etc/X11/xinit/xinitrc
    '';
  });

  xf86videointel = super.xf86videointel.overrideAttrs (attrs: {
    # the update script only works with released tarballs :-/
    name = "xf86-video-intel-2021-01-15";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      group = "xorg";
      owner = "driver";
      repo = "xf86-video-intel";
      rev = "31486f40f8e8f8923ca0799aea84b58799754564";
      sha256 = "sha256-nqT9VZDb2kAC72ot9UCdwEkM1uuP9NriJePulzrdZlM=";
    };
    buildInputs = attrs.buildInputs ++ [ xorg.libXScrnSaver xorg.libXv xorg.pixman xorg.utilmacros ];
    nativeBuildInputs = attrs.nativeBuildInputs ++ [autoreconfHook ];
    configureFlags = [ "--with-default-dri=3" "--enable-tools" ];
    patches = [ ./use_crocus_and_iris.patch ];

    meta = attrs.meta // {
      platforms = ["i686-linux" "x86_64-linux"];
    };
  });

  xf86videoopenchrome = super.xf86videoopenchrome.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ xorg.libXv ];
    patches = [
      # Pull upstream fix for -fno-common toolchains.
      (fetchpatch {
        name = "fno-common.patch";
        url = "https://github.com/freedesktop/openchrome-xf86-video-openchrome/commit/edb46574d4686c59e80569ba236d537097dcdd0e.patch";
        sha256 = "0xqawg9zzwb7x5vaf3in60isbkl3zfjq0wcnfi45s3hiii943sxz";
      })
    ];
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
      # Pull upstream fix for -fno-common toolchains.
      (fetchpatch {
        name = "fno-common.patch";
        url = "https://github.com/freedesktop/xorg-xf86-video-xgi/commit/3143bdee580c4d397e21adb0fa35502d4dc8e888.patch";
        sha256 = "0by6k26rj1xmljnbfd08v90s1f9bkmnf17aclhv50081m83lmm07";
      })
    ];
  });

  xorgcffiles = super.xorgcffiles.overrideAttrs (attrs: {
    patches = [
      (fetchpatch {
        name = "add-aarch64-darwin-support.patch";
        url = "https://gitlab.freedesktop.org/xorg/util/cf/-/commit/8d88c559b177e832b581c8ac0aa383b6cf79e0d0.patch";
        sha256 = "sha256-wCijdmlUtVgOh9Rp/LJrg1ObYm4OPTke5Xwu0xC0ap4=";
      })
    ];
    postInstall = lib.optionalString stdenv.isDarwin ''
      substituteInPlace $out/lib/X11/config/darwin.cf --replace "/usr/bin/" ""
    '';
  });

  xorgdocs = super.xorgdocs.overrideAttrs (attrs: {
    # This makes the man pages discoverable by the default man,
    # since it looks for packages in $PATH
    postInstall = "mkdir $out/bin";
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

  # convert Type1 vector fonts to OpenType fonts
  fontbitstreamtype1 = super.fontbitstreamtype1.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ fontforge ];

    postBuild = ''
      # convert Postscript (Type 1) font to otf
      for i in $(find -type f -name '*.pfa' -o -name '*.pfb'); do
          name=$(basename $i | cut -d. -f1)
          fontforge -lang=ff -c "Open(\"$i\"); Generate(\"$name.otf\")"
      done
    '';

    postInstall = ''
      # install the otf fonts
      fontDir="$out/lib/X11/fonts/misc/"
      install -D -m 644 -t "$fontDir" *.otf
      mkfontscale "$fontDir"
    '';
  });

}

# mark some packages as unfree
// (
  let
    # unfree but redistributable
    redist = [
      "fontadobeutopiatype1"
      "fontadobeutopia100dpi"
      "fontadobeutopia75dpi"
      "fontbhtype1"
      "fontibmtype1"
      "fontbhttf"
      "fontbh100dpi"
      "fontbh75dpi"

      # Bigelow & Holmes fonts
      # https://www.x.org/releases/current/doc/xorg-docs/License.html#Bigelow_Holmes_Inc_and_URW_GmbH_Luxi_font_license
      "fontbhlucidatypewriter100dpi"
      "fontbhlucidatypewriter75dpi"
    ];

    # unfree, possibly not redistributable
    unfree = [
      # no license, just a copyright notice
      "fontdaewoomisc"

      # unclear license, "permission to use"?
      "fontjismisc"
    ];

    setLicense = license: name:
      super.${name}.overrideAttrs (attrs: {
        meta = attrs.meta // { inherit license; };
      });
    mapNamesToAttrs = f: names: with lib;
      listToAttrs (zipListsWith nameValuePair names (map f names));

  in
    mapNamesToAttrs (setLicense lib.licenses.unfreeRedistributable) redist //
    mapNamesToAttrs (setLicense lib.licenses.unfree) unfree
)
