{args, xorg}:
let
   setMalloc0ReturnsNullCrossCompiling = ''
      if test -n "$crossConfig"; then
        configureFlags="$configureFlags --enable-malloc0returnsnull";
      fi
    '';
in
{

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
    preBuild = "substituteInPlace mkfontdir.cpp --replace BINDIR ${xorg.mkfontscale}/bin";
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

  libX11 = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
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

  libXt = attrs: attrs // {
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXft = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [ xorg.xproto xorg.libX11
        xorg.renderproto ];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXext = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXau];
    preConfigure = setMalloc0ReturnsNullCrossCompiling;
  };

  libXpm = attrs: attrs // {
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
  };

  setxkbmap = attrs: attrs // {
    postInstall =
      ''
        ensureDir $out/share
        ln -sfn ${args.xkeyboard_config}/etc/X11 $out/share/X11
      '';
  };

  xf86inputevdev = attrs: attrs // {
    configureFlags = "--with-sdkdir=\${out}/include/xorg";
    preBuild = "sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c";
    buildInputs = attrs.buildInputs ++ [xorg.kbproto xorg.libxkbfile xorg.randrproto];
  };

  xf86inputsynaptics = attrs: attrs // {
    makeFlags = "sdkdir=\${out}/include/xorg";
  };

  xf86videointel = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa];
  };

  xf86videosis = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa];
  };

  xf86videoati = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa];
  };

  xf86videoopenchrome = attrs: attrs // {
    name = "xf86-video-openchrome-svn-816";
    src = args.fetchsvn {
      url = http://svn.openchrome.org/svn/trunk;
      sha256 = "1mhfh1n1x7fnxdbbkbz13lzd57m6xi3n9cblzgm43mz5bamacr02";
      rev = 816;
      };
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa args.automake args.autoconf args.libtool xorg.libXext];
    preConfigure = "chmod +x autogen.sh";
    configureScript = "./autogen.sh";
  };

  xdriinfo = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa];
  };

  xkbcomp = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-DDFLT_XKB_CONFIG_ROOT=\".\"";
  };

  xorgserver = attrs: attrs // {
    patches = [./xorgserver-dri-path.patch ./xorgserver-xkbcomp-path.patch];
    buildInputs = attrs.buildInputs ++
      [ args.zlib args.udev args.mesa
        xorg.xf86bigfontproto xorg.glproto xorg.xf86driproto
        xorg.compositeproto xorg.scrnsaverproto xorg.resourceproto
        xorg.xineramaproto xorg.dri2proto xorg.xf86dgaproto
        xorg.dmxproto xorg.libdmx xorg.xf86vidmodeproto
        xorg.recordproto xorg.libXext
      ];
    propagatedBuildInputs =
      [ xorg.libpciaccess xorg.inputproto xorg.xextproto xorg.randrproto ];
    postInstall =
      ''
        rm -fr $out/share/X11/xkb/compiled
        ln -s /var/tmp $out/share/X11/xkb/compiled
      '';
  };

  libSM = attrs: attrs // args.stdenv.lib.optionalAttrs (args.stdenv.system == "i686-darwin") {
    configureFlags = "LIBUUID_CFLAGS='' LIBUUID_LIBS=''";
  };

  lndir = attrs: attrs // {
    preConfigure = ''
      substituteInPlace lndir.c \
        --replace 'n_dirs--;' ""
    '';
  };

}
