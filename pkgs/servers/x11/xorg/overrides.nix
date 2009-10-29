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

  libXext = attrs: attrs // {
    buildInputs = attrs.buildInputs ++ [xorg.libXau];
  };

  libXpm = attrs: attrs // {
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
  };

  libXaw = attrs: attrs // {
    # The libXaw installation is broken on MacOS X. The package has hard-coded
    # know-how that assumes shared libraries use an .so suffix. MacOS, however,
    # uses .dylib. Furthermore, the package fails to install an unversioned
    # libtool .la file for the library.
    postInstall = ''
      cd $out/lib
      ln -s libXaw8.la libXaw.la
      if [ ${args.stdenv.system} = "i686-darwin" ]; then
        rm *.so*
        ln -s libXaw8.dylib libXaw.dylib
      fi
    '';
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
    name = "xf86-video-openchrome-svn-798";
    src = args.fetchsvn {
      url = http://svn.openchrome.org/svn/trunk;
      sha256 = "00kz5775090nwlsxyqrp1wsmislszj58fv3kvq612xgql4vgx4ab";
      rev = 798;
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
    buildInputs = attrs.buildInputs ++
      [ args.zlib xorg.xf86bigfontproto xorg.glproto args.mesa xorg.xf86driproto
        xorg.compositeproto xorg.scrnsaverproto xorg.resourceproto
        xorg.xineramaproto xorg.dri2proto xorg.xf86dgaproto xorg.dmxproto
        xorg.libdmx xorg.xf86vidmodeproto
      ];
    propagatedBuildInputs = [xorg.libpciaccess xorg.inputproto];
    postInstall =
      ''
        rm -rf $out/share/X11/xkb/compiled
        ln -s /var/tmp $out/share/X11/xkb/compiled
      '';
  };

  libSM = attrs: attrs // args.stdenv.lib.optionalAttrs (args.stdenv.system == "i686-darwin") {
    configureFlags = "LIBUUID_CFLAGS='' LIBUUID_LIBS=''";
  };

}
