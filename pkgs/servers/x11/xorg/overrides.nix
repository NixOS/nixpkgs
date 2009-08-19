{args, xorg}:

{

  fontmiscmisc = attrs: attrs // {
    postInstall =
      ''
        ln -s ${xorg.fontalias}/lib/X11/fonts/misc/fonts.alias $out/lib/X11/fonts/misc/fonts.alias
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
    name = "xf86-video-openchrome-svn-754";
    src = args.fetchsvn {
      url = http://svn.openchrome.org/svn/trunk;
      md5 = "9a64a317d1f0792c5709e516c14f383b";
      rev = 754;
      };
    buildInputs = attrs.buildInputs ++ [xorg.glproto args.mesa args.automake args.autoconf args.libtool xorg.libXext];
    preConfigure = "chmod +x autogen.sh";
    configureScript = "./autogen.sh";
  };

  xkbcomp = attrs: attrs // {
    NIX_CFLAGS_COMPILE = "-DDFLT_XKB_CONFIG_ROOT=\".\"";
  };

  xorgserver = attrs: attrs // {
    patches = [./xorgserver-dri-path.patch ./xorgserver-xkbcomp-path.patch];
    buildInputs = attrs.buildInputs ++ [args.zlib xorg.xf86bigfontproto];
    propagatedBuildInputs = [xorg.libpciaccess];
    /*
    configureFlags = "--with-xkb-output=/var/tmp";
    postPatch = ''
      sed -i -e 's@ -w @ -I${args.xkeyboard_config}/etc/X11/xkb -w @' xkb/ddxLoad.c
    '';
    */
  };
  
}
