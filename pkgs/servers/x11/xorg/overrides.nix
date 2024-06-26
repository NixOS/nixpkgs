{
  callPackage,
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  fetchpatch,
  fetchFromGitLab,
  buildPackages,
  automake,
  autoconf,
  libiconv,
  libtool,
  intltool,
  gettext,
  python3,
  perl,
  freetype,
  tradcpp,
  fontconfig,
  meson,
  ninja,
  ed,
  fontforge,
  libGL,
  spice-protocol,
  zlib,
  libGLU,
  dbus,
  libunwind,
  libdrm,
  netbsd,
  ncompress,
  updateAutotoolsGnuConfigScriptsHook,
  mesa,
  udev,
  bootstrap_cmds,
  bison,
  flex,
  clangStdenv,
  autoreconfHook,
  mcpp,
  libepoxy,
  openssl,
  pkg-config,
  llvm,
  libxslt,
  libxcrypt,
  hwdata,
  ApplicationServices,
  Carbon,
  Cocoa,
  Xplugin,
  xorg,
  windows,
}:

let
  inherit (stdenv) isDarwin;

  malloc0ReturnsNullCrossFlag = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  addMainProgram =
    pkg:
    {
      mainProgram ? pkg.pname,
    }:
    pkg.overrideAttrs (attrs: {
      meta = attrs.meta // {
        inherit mainProgram;
      };
    });

  brokenOnDarwin =
    pkg:
    pkg.overrideAttrs (attrs: {
      meta = attrs.meta // {
        broken = isDarwin;
      };
    });
in
final: prev: {
  wrapWithXFileSearchPathHook = callPackage (
    {
      makeBinaryWrapper,
      makeSetupHook,
      writeScript,
    }:
    makeSetupHook
      {
        name = "wrapWithXFileSearchPathHook";
        propagatedBuildInputs = [ makeBinaryWrapper ];
      }
      (
        writeScript "wrapWithXFileSearchPathHook.sh" ''
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
        ''
      )
  ) { };

  appres = prev.appres.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mitOpenGroup;
      mainProgram = "appres";
    };
  });

  bdftopcf = prev.bdftopcf.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ xorg.xorgproto ];
    meta = attrs.meta // {
      license = lib.licenses.mitOpenGroup;
      mainProgram = "bdftopcf";
    };
  });

  bitmap = prev.bitmap.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mitOpenGroup;
      mainProgram = "bitmap";
    };
  });

  editres = prev.editres.overrideAttrs (attrs: {
    hardeningDisable = [ "format" ];
    meta = attrs.meta // {
      license = lib.licenses.mitOpenGroup;
      mainProgram = "editres";
    };
  });

  encodings = prev.encodings.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.publicDomain;
    };
  });

  fontadobe100dpi = prev.fontadobe100dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # HPND-sell-variant, but with Adobe trademark and no disclaimer
      license = lib.licenses.free;
    };
  });

  fontadobe75dpi = prev.fontadobe75dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # same as fontadobe100dpi
      license = lib.licenses.free;
    };
  });

  fontadobeutopia100dpi = prev.fontadobeutopia100dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.adobeUtopia;
    };
  });

  fontadobeutopia75dpi = prev.fontadobeutopia75dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.adobeUtopia;
    };
  });

  fontadobeutopiatype1 = prev.fontadobeutopiatype1.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.adobeUtopia;
    };
  });

  fontalias = prev.fontalias.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.cronyx;
    };
  });

  fontarabicmisc = prev.fontarabicmisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });


  # Lucida Bigelow & Holmes fonts
  # the legal notice only allows the the use of the software
  # there are no statements about it being redistributable
  # changing is not allowed unless is is "absolutely necessary"
  # the typewriter fonts only include a copyright
  # Wikipedia says the license is "commercial":
  # https://en.wikipedia.org/wiki/Lucida
  fontbh75dpi = prev.fontbh75dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.unfree;
    };
  });
  fontbh100dpi = prev.fontbh100dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.unfree;
    };
  });
  fontbhlucidatypewriter75dpi = prev.fontbhlucidatypewriter75dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.unfree;
    };
  });
  fontbhlucidatypewriter100dpi = prev.fontbhlucidatypewriter100dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.unfree;
    };
  });

  fontbhttf = prev.fontbhttf.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # Copyright notice permits using and distributing, but changing is explicitly disallowed.
      # Wikipedia says they are non-free (quoting Debian):
      # https://en.wikipedia.org/wiki/Luxi_fonts
      # https://web.archive.org/web/20141006121747/https://packages.debian.org/wheezy/ttf-xfree86-nonfree
      license = lib.licenses.unfreeRedistributable;
    };
  });

  fontbhtype1 = prev.fontbhtype1.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # same license as fontbhttf
      license = lib.licenses.unfreeRedistributable;
    };
  });

  fontbitstream100dpi = prev.fontbitstream100dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = with lib.licenses; [
        free
        bitstreamCharter
      ];
    };
  });

  fontbitstream75dpi = prev.fontbitstream75dpi.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = with lib.licenses; [
        free
        bitstreamCharter
      ];
    };
  });

  fontbitstreamtype1 = prev.fontbitstreamtype1.overrideAttrs (attrs: {
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

    meta = attrs.meta // {
      license = lib.licenses.bitstreamCharter;
    };
  });

  fontbitstreamspeedo = prev.fontbitstreamspeedo.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.bitstreamCharter;
    };
  });

  fontcronyxcyrillic = prev.fontcronyxcyrillic.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.cronyx;
    };
  });

  fontcursormisc = prev.fontcursormisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # whatever this is supposed to mean:
      # "These ""glyphs"" are unencumbered"
      license = lib.licenses.unfree;
    };
  });

  fontdaewoomisc = prev.fontdaewoomisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # no license, just a copyright notice
      license = lib.licenses.unfree;
    };
  });

  fontdecmisc = prev.fontdecmisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  fontibmtype1 = prev.fontibmtype1.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # The COPYING file doesn't state anything about the font being allowed to be modified.
      # OpenMandriva agrees that the font is not allowed to be modified:
      # https://github.com/OpenMandrivaAssociation/x11-font-ibm-type1/blob/11b1ac6c83aed0e9205876da3d4ed78cc606f981/x11-font-ibm-type1.spec
      license = lib.licenses.unfreeRedistributable;
    };
  });

  fontisasmisc = prev.fontisasmisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  fontjismisc = prev.fontjismisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # unclear license: "permission to use"
      # however Wikipedia says it is public domain:
      # https://ja.wikipedia.org/w/index.php?title=Jiskan&oldid=100304028
      # Apparantly, because Japan didn't have copyright when the original font was created.
      license = lib.licenses.publicDomain;
    };
  });

  fontmicromisc = prev.fontmicromisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.publicDomain;
    };
  });

  fontmisccyrillic = prev.fontmisccyrillic.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = with lib.licenses; [
        # koi12x24b.bdf, koi8x16b.bdf and koi8x16.bdf:
        # > May be distributed and modified without restrictions.
        # assuming permission to use this is free

        # koi12x24.bdf and koi6x13.bdf:
        free

        # koi5x8.bdf, koi6x13b.bdf, koi6x9.bdf, koi7x14b.bdf, koi7x14.bdf,
        # koi8x13.bdf, koi9x15b.bdf, koi9x15.bdf, koi9x18b.bdf and koi9x18.bdf:
        publicDomain
      ];
    };
  });

  fontmiscethiopic = prev.fontmiscethiopic.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });

  fontmiscmeltho = prev.fontmiscmeltho.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # modified version of the Lucida Bigelow & Holmes Font License
      # still unfree tho  :(
      license = lib.licenses.unfree;
    };
  });

  fontmiscmisc = prev.fontmiscmisc.overrideAttrs (attrs: {
    postInstall = ''
      ALIASFILE=${xorg.fontalias}/share/fonts/X11/misc/fonts.alias
      test -f $ALIASFILE
      cp $ALIASFILE $out/lib/X11/fonts/misc/fonts.alias
    '';
    meta = attrs.meta // {
      license = lib.licenses.publicDomain;
    };
  });

  fontmuttmisc = prev.fontmuttmisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });

  fontschumachermisc = prev.fontschumachermisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.ntp;
    };
  });

  fontscreencyrillic = prev.fontscreencyrillic.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # unknown permission notice that grants all 4 freedoms
      license = lib.licenses.cronyx;
    };
  });

  fontsonymisc = prev.fontsonymisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  fontsunmisc = prev.fontsunmisc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });

  fonttosfnt = prev.fonttosfnt.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mit;
      mainProgram = "fonttosfnt";
    };
  });

  fontutil = prev.fontutil.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = with lib.licenses; [
        mit
        bsd2
        bsdSourceCode
        mitOpenGroup
        # Unicode Terms Of Use is included, not sure if this is also a license
      ];
    };
  });

  fontwinitzkicyrillic = prev.fontwinitzkicyrillic.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.publicDomain;
    };
  });

  fontxfree86type1 = prev.fontxfree86type1.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.x11;
    };
  });

  gccmakedep = prev.gccmakedep.overrideAttrs (prev: {
    meta = prev // {
      license = with lib.licenses; [
        # COPYING file suggests looking at the Copyright headers of every file:
        gpl2Plus
        gpl3Plus
        hpndSellVariant
        x11
        # gccmakedep.man was written by Colin Watson for Debian somewhen earlier than November 2003.
        # While I wasn't able to trace the exact source, between 1997 and 2004 the
        # "Debian Social Contract, Version 1.0" was in effect, which requires all components
        # of the Debian Operating System to be free software, which includes this man page.
        # https://www.debian.org/social_contract.1.0
        free
        # gccmakedep.in is "Based on mdepend.cpp and code supplied by Hongjiu Lu <hjl@nynexst.com>"
        # mdepend.cpp is part of motif, which at the time of basing the file on it was proprietary
        # TODO: look into if that is now retroactively considered LGPL, since newer motif versions are LGPL-2.1
        # The license of the code by Hongjiu Lu is unclear.
        # I also asked Kaleb Keithley, the guy who commited that code, if they know something.
        unfree
      ];
      mainProgram = "gccmakedep";
    };
  });

  iceauth = prev.iceauth.overrideAttrs (prev: {
    meta = prev // {
      license = lib.licenses.mitOpenGroup;
      mainProgram = "iceauth";
    };
  });

  ico = prev.ico.overrideAttrs (prev: {
    meta = prev // {
      license = with lib.licenses; [
        x11
        smlnj
        hpndSellVariant
      ];
      mainProgram = "ico";
    };
  });

  imake = prev.imake.overrideAttrs (attrs: {
    inherit (xorg) xorgcffiles;
    x11BuildHook = ./imake.sh;
    patches = [
      ./imake.patch
      ./imake-cc-wrapper-uberhack.patch
    ];
    setupHook = ./imake-setup-hook.sh;
    CFLAGS = "-DIMAKE_COMPILETIME_CPP='\"${if stdenv.isDarwin then "${tradcpp}/bin/cpp" else "gcc"}\"'";

    configureFlags = attrs.configureFlags or [ ] ++ [
      "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp"
    ];

    inherit tradcpp;

    meta = attrs.meta // {
      license = with lib.licenses; [
        x11
        mitOpenGroup
      ];
      mainProgram = "imake";
    };
  });

  libAppleWM = prev.libAppleWM.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ ApplicationServices ];
    preConfigure = ''
      substituteInPlace src/Makefile.in --replace -F/System -F${ApplicationServices}
    '';
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });

  libdmx = prev.libdmx.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });

  libfontenc = prev.libfontenc.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });

  libFS = prev.libFS.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = with lib.licenses; [
        mitOpenGroup
        hpndSellVariant
      ];
    };
  });

  libICE = prev.libICE.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "doc"
    ];
    meta = attrs.meta // {
      license = lib.licenses.mitOpenGroup;
    };
  });

  libpciaccess = prev.libpciaccess.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [
      meson
      ninja
    ];

    buildInputs =
      attrs.buildInputs
      ++ [ zlib ]
      ++ lib.optionals stdenv.hostPlatform.isNetBSD (
        with netbsd;
        [
          libarch
          libpci
        ]
      );

    mesonFlags = [
      (lib.mesonOption "pci-ids" "${hwdata}/share/hwdata")
      (lib.mesonEnable "zlib" true)
    ];

    meta = attrs.meta // {
      license = with lib.licenses; [
        mit
        isc
        x11
      ];
      # https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/blob/master/configure.ac#L108-114
      platforms = lib.fold (os: ps: ps ++ lib.platforms.${os}) [ ] [
        "cygwin"
        "freebsd"
        "linux"
        "netbsd"
        "openbsd"
        "illumos"
      ];
      badPlatforms = [
        # mandatory shared library
        lib.systems.inspect.platformPatterns.isStatic
      ];
    };
  });

  libpthreadstubs = prev.libpthreadstubs.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.x11DistributeModifications; # but with missing copyright notice
      # only contains a pkgconfig file on linux and windows
      platforms = lib.platforms.unix ++ lib.platforms.windows;
    };
  });

  libSM = prev.libSM.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "doc"
    ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ xorg.libICE ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        mit
        mitOpenGroup
      ];
    };
  });

  libWindowsWM = prev.libWindowsWM.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });

  libX11 = prev.libX11.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "man"
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    depsBuildBuild =
      [ buildPackages.stdenv.cc ]
      ++ lib.optionals stdenv.hostPlatform.isStatic [
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
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ xorg.xorgproto ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        mitOpenGroup
        x11
        mit
        hpndSellVariant
        hpnd
        smlnj
        bsd1
        isc
        hpndDocSell
        # some unknown permission notices that grant all 4 freedoms
        free
        # quite a few files carry this copyright notice:
        # > (c) Copyright 1995 FUJITSU LIMITED
        # > This is source code modified by FUJITSU LIMITED under the Joint
        # > Development Agreement for the CDE/Motif PST.
        # commit 5e7d589697755a70fb22d85c6a1ae82b39843e53 removes 2 files
        # with the same copyright notice and states:
        # > This is unpublished proprietary source code of FUJITSU LIMITED
        unfree
      ];
    };
  });

  libXau = prev.libXau.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ xorg.xorgproto ];
    meta = attrs.meta // {
      license = lib.licenses.mitOpenGroup;
    };
  });

  libXaw = prev.libXaw.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "devdoc"
    ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ xorg.libXmu ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        mitOpenGroup
        x11
        hpndSellVariant
        smlnj
        ntp
        # some unknown permission notices that grant all 4 freedoms
        # may also be known, but i couldn't find a license that matches
        free
      ];
    };
  });

  libxcb = prev.libxcb.overrideAttrs (attrs: {
    # $dev/include/xcb/xcb.h includes pthread.h
    propagatedBuildInputs =
      attrs.propagatedBuildInputs or [ ]
      ++ lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64_pthreads;
    configureFlags = [
      "--enable-xkb"
      "--enable-xinput"
    ] ++ lib.optional stdenv.hostPlatform.isStatic "--disable-shared";
    outputs = [
      "out"
      "dev"
      "man"
      "doc"
    ];
    meta = attrs.meta // {
      license = lib.licenses.x11DistributeModifications;
      pkgConfigModules = [
        "xcb-composite"
        "xcb-damage"
        "xcb-dpms"
        "xcb-dri2"
        "xcb-dri3"
        "xcb-glx"
        "xcb-present"
        "xcb-randr"
        "xcb-record"
        "xcb-render"
        "xcb-res"
        "xcb-screensaver"
        "xcb-shape"
        "xcb-shm"
        "xcb-sync"
        "xcb-xf86dri"
        "xcb-xfixes"
        "xcb-xinerama"
        "xcb-xinput"
        "xcb-xkb"
        "xcb-xtest"
        "xcb-xv"
        "xcb-xvmc"
        "xcb"
      ];
      platforms = lib.platforms.unix ++ lib.platforms.windows;
    };
  });

  libXcomposite = prev.libXcomposite.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ xorg.libXfixes ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        hpndSellVariant
        mit
      ];
    };
  });

  libXcursor = prev.libXcursor.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  libxcvt = prev.libxcvt.overrideAttrs (attrs: {
    meta = (attrs.meta or { }) // {
      homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcvt";
      license = with lib.licenses; [
        mit
        hpndSellVariant
      ];
      mainProgram = "cvt";
      badPlatforms = attrs.meta.badPlatforms or [ ] ++ [ lib.systems.inspect.platformPatterns.isStatic ];
    };
  });

  libXdamage = prev.libXdamage.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  libXdmcp = prev.libXdmcp.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "doc"
    ];
    meta = attrs.meta // {
      license = lib.licenses.mitOpenGroup;
      pkgConfigModules = [ "xdmcp" ];
    };
  });

  libXext = prev.libXext.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "man"
      "doc"
    ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
      xorg.xorgproto
      xorg.libXau
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = with lib.licenses; [
        mitOpenGroup
        x11DistributeModifications
        hpndSellVariant
        smlnj
        ntp
        x11
        hpndDocSell
        mit
        isc
      ];
    };
  });

  libXfixes = prev.libXfixes.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        hpndSellVariant
        mit
      ];
    };
  });

  libXfont = prev.libXfont.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ freetype ]; # propagate link reqs. like bzip2
    # prevents "misaligned_stack_error_entering_dyld_stub_binder"
    configureFlags = lib.optional isDarwin "CFLAGS=-O0";
    meta = attrs.meta // {
      license = with lib.licenses; [
        mit
        mitOpenGroup
        smlnj
        hpndSellVariant
        bsdOriginalUC
        bsd2
        # lib/font/fontfile/gunzip.c
        # > intended for inclusion in X11 public releases.
        # as well as the last license in COPYING grants no freedoms
        unfree
      ];
    };
  });

  libXfont2 = prev.libXfont2.overrideAttrs (attrs: {
    meta = attrs.meta // {
      # same COPYING file as libXfont
      license = final.libXfont.meta.license;
    };
  });

  libXft = prev.libXft.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
      xorg.libXrender
      freetype
      fontconfig
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;

    # the include files need ft2build.h, and Requires.private isn't enough for us
    postInstall = ''
      sed "/^Requires:/s/$/, freetype2/" -i "$dev/lib/pkgconfig/xft.pc"
    '';
    passthru = attrs.passthru // {
      inherit freetype fontconfig;
    };
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  libXi = prev.libXi.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "man"
      "doc"
    ];
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
      xorg.libXfixes
      xorg.libXext
    ];
    configureFlags =
      lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "xorg_cv_malloc0_returns_null=no" ]
      ++ lib.optional stdenv.hostPlatform.isStatic "--disable-shared";
    meta = attrs.meta // {
      license = with lib.licenses; [
        mitOpenGroup
        smlnj
        mit
      ];
    };
  });

  libXinerama = prev.libXinerama.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = with lib.licenses; [
        mitOpenGroup
        mit
      ];
    };
  });

  libxkbfile = prev.libxkbfile.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # mainly to avoid propagation
    meta = attrs.meta // {
      license = with lib.licenses; [
        hpndSellVariant
        mitOpenGroup
        smlnj
      ];
    };
  });

  libXmu = prev.libXmu.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "doc"
    ];
    buildFlags = [ "BITMAP_DEFINES='-DBITMAPDIR=\"/no-such-path\"'" ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        mitOpenGroup
        smlnj
        x11
        isc
      ];
    };
  });

  libXp = prev.libXp.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        x11DistributeModifications
        x11
      ];
    };
  });

  libXpm = prev.libXpm.overrideAttrs (attrs: {
    outputs = [
      "bin"
      "dev"
      "out"
    ]; # tiny man in $bin
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
    XPM_PATH_COMPRESS = lib.makeBinPath [ ncompress ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        x11
        mit
      ];
      mainProgram = "sxpm";
    };
  });

  libXpresent = prev.libXpresent.overrideAttrs (attrs: {
    buildInputs =
      with xorg;
      attrs.buildInputs
      ++ [
        libXext
        libXfixes
        libXrandr
      ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        hpndSellVariant
        mit
      ];
    };
  });

  libXrandr = prev.libXrandr.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ xorg.libXrender ];
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  libXrender = prev.libXrender.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "doc"
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ xorg.xorgproto ];
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  libXres = prev.libXres.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "devdoc"
    ];
    buildInputs = with xorg; attrs.buildInputs ++ [ utilmacros ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = lib.licenses.x11;
    };
  });

  libXScrnSaver = prev.libXScrnSaver.overrideAttrs (attrs: {
    buildInputs = with xorg; attrs.buildInputs ++ [ utilmacros ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = lib.licenses.x11;
    };
  });

  libxshmfence = prev.libxshmfence.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # mainly to avoid propagation
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  # Propagate some build inputs because of header file dependencies.
  # Note: most of these are in Requires.private, so maybe builder.sh
  # should propagate them automatically.
  libXt = prev.libXt.overrideAttrs (attrs: {
    preConfigure = ''
      sed 's,^as_dummy.*,as_dummy="\$PATH",' -i configure
    '';
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ xorg.libSM ];
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    CPP = if stdenv.isDarwin then "clang -E -" else "${stdenv.cc.targetPrefix}cc -E -";
    outputDoc = "devdoc";
    outputs = [
      "out"
      "dev"
      "devdoc"
    ];
    meta = attrs.meta // {
      license = with lib.licenses; [
        mit
        hpndSellVariant
        smlnj
        mitOpenGroup
        x11
      ];
    };
  });

  libXTrap = prev.libXTrap.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.hpndSellVariant;
    };
  });

  libXtst = prev.libXtst.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = with lib.licenses; [
        mitOpenGroup
        smlnj
        hpndSellVariant
        x11
        hpndDocSell
      ];
      pkgConfigModules = [ "xtst" ];
    };
  });

  libXv = prev.libXv.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "devdoc"
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = with lib.licenses; [
        smlnj
        hpndSellVariant
      ];
    };
  });

  libXvMC = prev.libXvMC.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
      "doc"
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    buildInputs = attrs.buildInputs ++ [ xorg.xorgproto ];
    meta = attrs.meta // {
      license = lib.licenses.mit;
    };
  });

  libXxf86dga = prev.libXxf86dga.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = lib.licenses.x11DistributeModifications;
    };
  });

  libXxf86misc = prev.libXxf86misc.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = lib.licenses.x11DistributeModifications;
    };
  });

  libXxf86vm = prev.libXxf86vm.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    meta = attrs.meta // {
      license = lib.licenses.x11;
    };
  });

  listres = addMainProgram prev.listres { };

  xdpyinfo = prev.xdpyinfo.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    preConfigure =
      attrs.preConfigure or ""
      # missing transitive dependencies
      + lib.optionalString stdenv.hostPlatform.isStatic ''
        export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lXau -lXdmcp"
      '';
    meta = attrs.meta // {
      mainProgram = "xdpyinfo";
    };
  });

  xdm = prev.xdm.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ libxcrypt ];
    configureFlags =
      attrs.configureFlags or [ ]
      ++ [ "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp" ]
      ++
        lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform)
          # checking for /dev/urandom... configure: error: cannot check for file existence when cross compiling
          [
            "ac_cv_file__dev_urandom=true"
            "ac_cv_file__dev_random=true"
          ];
    meta = attrs.meta // {
      mainProgram = "xdm";
    };
  });

  luit = prev.luit.overrideAttrs (attrs: {
    # See https://bugs.freedesktop.org/show_bug.cgi?id=47792
    # Once the bug is fixed upstream, this can be removed.
    configureFlags = [ "--disable-selective-werror" ];

    buildInputs = attrs.buildInputs ++ [ libiconv ];
    meta = attrs.meta // {
      mainProgram = "luit";
    };
  });

  setxkbmap = prev.setxkbmap.overrideAttrs (attrs: {
    postInstall = ''
      mkdir -p $out/share/man/man7
      ln -sfn ${xorg.xkeyboardconfig}/etc/X11 $out/share/X11
      ln -sfn ${xorg.xkeyboardconfig}/share/man/man7/xkeyboard-config.7.gz $out/share/man/man7
    '';
    meta = attrs.meta // {
      mainProgram = "setxkbmap";
    };
  });

  makedepend = addMainProgram prev.makedepend { };
  mkfontdir = xorg.mkfontscale;
  mkfontscale = addMainProgram prev.mkfontscale { };
  oclock = addMainProgram prev.oclock { };
  smproxy = addMainProgram prev.smproxy { };
  transset = addMainProgram prev.transset { };

  utilmacros = prev.utilmacros.overrideAttrs (attrs: {
    # not needed for releases, we propagate the needed tools
    propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
      automake
      autoconf
      libtool
    ];
  });

  viewres = addMainProgram prev.viewres { };

  x11perf = prev.x11perf.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [
      freetype
      fontconfig
    ];
    meta = attrs.meta // {
      mainProgram = "x11perf";
    };
  });

  xcalc = addMainProgram prev.xcalc { };

  xcbutil = prev.xcbutil.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
  });

  xcbutilerrors = prev.xcbutilerrors.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # mainly to get rid of propagating others
  });

  xcbutilcursor = prev.xcbutilcursor.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    meta = attrs.meta // {
      maintainers = [ lib.maintainers.lovek323 ];
    };
  });

  xcbutilimage = prev.xcbutilimage.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # mainly to get rid of propagating others
  });

  xcbutilkeysyms = prev.xcbutilkeysyms.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # mainly to get rid of propagating others
  });

  xcbutilrenderutil = prev.xcbutilrenderutil.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # mainly to get rid of propagating others
  });

  xcbutilwm = prev.xcbutilwm.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # mainly to get rid of propagating others
  });

  xf86inputevdev = prev.xf86inputevdev.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # to get rid of xorgserver.dev; man is tiny
    preBuild = "sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c";
    configureFlags = [ "--with-sdkdir=${placeholder "dev"}/include/xorg" ];
  });

  xf86inputmouse = prev.xf86inputmouse.overrideAttrs (attrs: {
    configureFlags = [ "--with-sdkdir=${placeholder "out"}/include/xorg" ];
    meta = attrs.meta // {
      broken = isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputmouse.x86_64-darwin
    };
  });

  xf86inputjoystick = prev.xf86inputjoystick.overrideAttrs (attrs: {
    configureFlags = [ "--with-sdkdir=${placeholder "out"}/include/xorg" ];
    meta = attrs.meta // {
      broken = isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputjoystick.x86_64-darwin
    };
  });

  xf86inputkeyboard = prev.xf86inputkeyboard.overrideAttrs (attrs: {
    meta = attrs.meta // {
      platforms = lib.platforms.freebsd ++ lib.platforms.netbsd ++ lib.platforms.openbsd;
    };
  });

  xf86inputlibinput = prev.xf86inputlibinput.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    configureFlags = [ "--with-sdkdir=${placeholder "dev"}/include/xorg" ];
  });

  xf86inputsynaptics = prev.xf86inputsynaptics.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # *.pc pulls xorgserver.dev
    configureFlags = [
      "--with-sdkdir=${placeholder "dev"}/include/xorg"
      "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
    ];
  });

  xf86inputvmmouse = prev.xf86inputvmmouse.overrideAttrs (attrs: {
    configureFlags = [
      "--sysconfdir=${placeholder "out"}/etc"
      "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
      "--with-udev-rules-dir=${placeholder "out"}/lib/udev/rules.d"
    ];

    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  });

  xf86inputvoid = brokenOnDarwin prev.xf86inputvoid; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputvoid.x86_64-darwin
  xf86videodummy = brokenOnDarwin prev.xf86videodummy; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videodummy.x86_64-darwin

  # Obsolete drivers that don't compile anymore.
  xf86videoark = prev.xf86videoark.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videogeode = prev.xf86videogeode.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videoglide = prev.xf86videoglide.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videoi128 = prev.xf86videoi128.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videonewport = prev.xf86videonewport.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videos3virge = prev.xf86videos3virge.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videotga = prev.xf86videotga.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videov4l = prev.xf86videov4l.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videovoodoo = prev.xf86videovoodoo.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videowsfb = prev.xf86videowsfb.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });

  xf86videoomap = prev.xf86videoomap.overrideAttrs (attrs: {
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=format-overflow" ];
  });

  xf86videoamdgpu = prev.xf86videoamdgpu.overrideAttrs (attrs: {
    configureFlags = [ "--with-xorg-conf-dir=$(out)/share/X11/xorg.conf.d" ];
  });

  xf86videonouveau = prev.xf86videonouveau.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook ];
    buildInputs = attrs.buildInputs ++ [ xorg.utilmacros ];
  });

  xf86videoglint = prev.xf86videoglint.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook ];
    buildInputs = attrs.buildInputs ++ [ xorg.utilmacros ];
    # https://gitlab.freedesktop.org/xorg/driver/xf86-video-glint/-/issues/1
    meta = attrs.meta // {
      broken = true;
    };
  });

  xf86videosuncg6 = prev.xf86videosuncg6.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = isDarwin;
    }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosuncg6.x86_64-darwin
  });

  xf86videosunffb = prev.xf86videosunffb.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = isDarwin;
    }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosunffb.x86_64-darwin
  });

  xf86videosunleo = prev.xf86videosunleo.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = isDarwin;
    }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosunleo.x86_64-darwin
  });

  xf86videovmware = prev.xf86videovmware.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [
      mesa
      mesa.driversdev
      llvm
    ]; # for libxatracker
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=address" ]; # gcc12
    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  });

  xf86videoqxl = prev.xf86videoqxl.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ spice-protocol ];
  });

  xf86videosiliconmotion = prev.xf86videosiliconmotion.overrideAttrs (attrs: {
    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  });

  xdriinfo = prev.xdriinfo.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ libGL ];
    meta = attrs.meta // {
      mainProgram = "xdriinfo";
    };
  });

  xev = addMainProgram prev.xev { };
  xeyes = addMainProgram prev.xeyes { };

  xvinfo = prev.xvinfo.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ xorg.libXext ];
    meta = attrs.meta // {
      mainProgram = "xvinfo";
    };
  });

  xkbcomp = prev.xkbcomp.overrideAttrs (attrs: {
    configureFlags = [ "--with-xkb-config-root=${xorg.xkeyboardconfig}/share/X11/xkb" ];
    meta = attrs.meta // {
      mainProgram = "xkbcomp";
    };
  });

  xkeyboardconfig = prev.xkeyboardconfig.overrideAttrs (attrs: {
    prePatch = ''
      patchShebangs rules/merge.py rules/compat/map-variants.py rules/xml2lst.pl
    '';
    nativeBuildInputs = attrs.nativeBuildInputs ++ [
      meson
      ninja
      python3
      perl
      libxslt # xsltproc
      gettext # msgfmt
    ];
    mesonFlags = [ (lib.mesonBool "xorg-rules-symlinks" true) ];
    # 1: compatibility for X11/xkb location
    # 2: I think pkg-config/ is supposed to be in /lib/
    postInstall = ''
      ln -s share "$out/etc"
      mkdir -p "$out/lib" && ln -s ../share/pkgconfig "$out/lib/"
    '';
  });

  # xkeyboardconfig variant extensible with custom layouts.
  # See nixos/modules/services/x11/extra-layouts.nix
  xkeyboardconfig_custom =
    {
      layouts ? { },
    }:
    let
      patchIn =
        name: layout:
        with layout;
        with lib;
        ''
          # install layout files
          ${optionalString (compatFile != null) "cp '${compatFile}'   'compat/${name}'"}
          ${optionalString (geometryFile != null) "cp '${geometryFile}' 'geometry/${name}'"}
          ${optionalString (keycodesFile != null) "cp '${keycodesFile}' 'keycodes/${name}'"}
          ${optionalString (symbolsFile != null) "cp '${symbolsFile}'  'symbols/${name}'"}
          ${optionalString (typesFile != null) "cp '${typesFile}'    'types/${name}'"}

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
      postPatch = with lib; concatStrings (mapAttrsToList patchIn layouts);
    });

  xlsfonts = prev.xlsfonts.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mit;
      mainProgram = "xlsfonts";
    };
  });

  xorgproto = prev.xorgproto.overrideAttrs (attrs: {
    buildInputs = [ ];
    propagatedBuildInputs = [ ];
    nativeBuildInputs = attrs.nativeBuildInputs ++ [
      meson
      ninja
    ];
    # adds support for printproto needed for libXp
    mesonFlags = [ "-Dlegacy=true" ];

    patches = [
      (fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/meson.patch?h=mingw-w64-xorgproto&id=7b817efc3144a50e6766817c4ca7242f8ce49307";
        sha256 = "sha256-Izzz9In53W7CC++k1bLr78iSrmxpFm1cH8qcSpptoUQ=";
      })
    ];
    meta = attrs.meta // {
      platforms = lib.platforms.unix ++ lib.platforms.windows;
    };
  });

  xorgserver =
    with xorg;
    prev.xorgserver.overrideAttrs (
      attrs_passed:
      let
        attrs = attrs_passed // {
          buildInputs = attrs_passed.buildInputs ++ lib.optional (libdrm != null) libdrm.dev;
          postPatch = ''
            for i in dri3/*.c
            do
              sed -i -e "s|#include <drm_fourcc.h>|#include <libdrm/drm_fourcc.h>|" $i
            done
          '';
          meta = attrs_passed.meta // {
            mainProgram = "X";
          };
        };
      in
      attrs
      // (
        let
          version = lib.getVersion attrs;
          commonBuildInputs = attrs.buildInputs ++ [
            xtrans
            libxcvt
          ];
          commonPropagatedBuildInputs = [
            dbus
            libGL
            libGLU
            libXext
            libXfont
            libXfont2
            libepoxy
            libunwind
            libxshmfence
            pixman
            xorgproto
            zlib
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

          fpgit =
            commit: sha256: name:
            fetchpatch (
              {
                url = "https://gitlab.freedesktop.org/xorg/xserver/-/commit/${commit}.diff";
                inherit sha256;
              }
              // lib.optionalAttrs (name != null) { name = name + ".patch"; }
            );
        in
        if (!isDarwin) then
          {
            outputs = [
              "out"
              "dev"
            ];
            patches = [
              # The build process tries to create the specified logdir when building.
              #
              # We set it to /var/log which can't be touched from inside the sandbox causing the build to hard-fail
              ./dont-create-logdir-during-build.patch
            ];
            buildInputs = commonBuildInputs ++ [
              libdrm
              mesa
            ];
            propagatedBuildInputs =
              attrs.propagatedBuildInputs or [ ]
              ++ [ libpciaccess ]
              ++ commonPropagatedBuildInputs
              ++ lib.optionals stdenv.isLinux [ udev ];
            depsBuildBuild = [ buildPackages.stdenv.cc ];
            prePatch = lib.optionalString stdenv.hostPlatform.isMusl ''
              export CFLAGS+=" -D__uid_t=uid_t -D__gid_t=gid_t"
            '';
            configureFlags = [
              "--enable-kdrive" # not built by default
              "--enable-xephyr"
              "--enable-xcsecurity" # enable SECURITY extension
              "--with-default-font-path="
              # there were only paths containing "${prefix}",
              # and there are no fonts in this package anyway
              "--with-xkb-bin-directory=${xorg.xkbcomp}/bin"
              "--with-xkb-path=${xorg.xkeyboardconfig}/share/X11/xkb"
              "--with-xkb-output=$out/share/X11/xkb/compiled"
              "--with-log-dir=/var/log"
              "--enable-glamor"
              "--with-os-name=Nix" # r13y, embeds the build machine's kernel version otherwise
            ] ++ lib.optionals stdenv.hostPlatform.isMusl [ "--disable-tls" ];

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
            passthru = attrs.passthru // {
              inherit version; # needed by virtualbox guest additions
            };
          }
        else
          {
            nativeBuildInputs = attrs.nativeBuildInputs ++ [
              autoreconfHook
              bootstrap_cmds
              xorg.utilmacros
              xorg.fontutil
            ];
            buildInputs = commonBuildInputs ++ [
              bootstrap_cmds
              automake
              autoconf
              Xplugin
              Carbon
              Cocoa
            ];
            propagatedBuildInputs = commonPropagatedBuildInputs ++ [
              libAppleWM
              xorgproto
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
              ./darwin/bundle_main.patch
              ./darwin/stub.patch
            ];

            postPatch =
              attrs.postPatch
              + ''
                substituteInPlace hw/xquartz/mach-startup/stub.c \
                  --subst-var-by XQUARTZ_APP "$out/Applications/XQuartz.app"
              '';

            configureFlags = [
              # note: --enable-xquartz is auto
              "CPPFLAGS=-I${./darwin/dri}"
              "--disable-glamor"
              "--with-default-font-path="
              "--with-apple-application-name=XQuartz"
              "--with-apple-applications-dir=\${out}/Applications"
              "--with-bundle-id-prefix=org.nixos.xquartz"
              "--with-sha1=CommonCrypto"
              "--with-xkb-bin-directory=${xorg.xkbcomp}/bin"
              "--with-xkb-path=${xorg.xkeyboardconfig}/share/X11/xkb"
              "--with-xkb-output=$out/share/X11/xkb/compiled"
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
            '';
            passthru = attrs.passthru // {
              inherit version;
            };
          }
      )
    );

  lndir = prev.lndir.overrideAttrs (attrs: {
    buildInputs = [ ];
    nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];
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
    meta = attrs.meta // {
      mainProgram = "lndir";
    };
  });

  twm = prev.twm.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [
      bison
      flex
    ];
    meta = attrs.meta // {
      mainProgram = "twm";
    };
  });

  xauth = prev.xauth.overrideAttrs (attrs: {
    doCheck = false; # fails
    preConfigure =
      attrs.preConfigure or ""
      # missing transitive dependencies
      + lib.optionalString stdenv.hostPlatform.isStatic ''
        export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lxcb -lXau -lXdmcp"
      '';
    meta = attrs.meta // {
      mainProgram = "xauth";
    };
  });

  xbacklight = addMainProgram prev.xbacklight { };
  xclock = addMainProgram prev.xclock { };
  xcmsdb = addMainProgram prev.xcmsdb { };
  xcompmgr = addMainProgram prev.xcompmgr { };
  xconsole = addMainProgram prev.xconsole { };
  xcursorgen = addMainProgram prev.xcursorgen { };

  xcursorthemes = prev.xcursorthemes.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ xorg.xcursorgen ];
    buildInputs = attrs.buildInputs ++ [ xorg.xorgproto ];
    configureFlags = [ "--with-cursordir=$(out)/share/icons" ];
  });

  xinit =
    (prev.xinit.override { stdenv = if isDarwin then clangStdenv else stdenv; }).overrideAttrs
      (attrs: {
        nativeBuildInputs = attrs.nativeBuildInputs ++ lib.optional isDarwin bootstrap_cmds;
        depsBuildBuild = [ buildPackages.stdenv.cc ];
        configureFlags =
          [ "--with-xserver=${xorg.xorgserver.out}/bin/X" ]
          ++ lib.optionals isDarwin [
            "--with-bundle-id-prefix=org.nixos.xquartz"
            "--with-launchdaemons-dir=\${out}/LaunchDaemons"
            "--with-launchagents-dir=\${out}/LaunchAgents"
          ];
        postPatch = ''
          # Avoid replacement of word-looking cpp's builtin macros in Nix's cross-compiled paths
          substituteInPlace Makefile.in --replace "PROGCPPDEFS =" "PROGCPPDEFS = -Dlinux=linux -Dunix=unix"
        '';
        propagatedBuildInputs =
          attrs.propagatedBuildInputs or [ ]
          ++ [ xorg.xauth ]
          ++ lib.optionals isDarwin [
            xorg.libX11
            xorg.xorgproto
          ];
        postFixup = ''
          substituteInPlace $out/bin/startx \
            --replace $out/etc/X11/xinit/xserverrc /etc/X11/xinit/xserverrc \
            --replace $out/etc/X11/xinit/xinitrc /etc/X11/xinit/xinitrc
        '';
        meta = attrs.meta // {
          mainProgram = "xinit";
        };
      });

  xf86videointel = prev.xf86videointel.overrideAttrs (attrs: {
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
    buildInputs = attrs.buildInputs ++ [
      xorg.libXScrnSaver
      xorg.libXv
      xorg.pixman
      xorg.utilmacros
    ];
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook ];
    configureFlags = [
      "--with-default-dri=3"
      "--enable-tools"
    ];
    patches = [ ./use_crocus_and_iris.patch ];

    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
      license = with lib.licenses; [
        hpndSellVariant
        mit
      ];
    };
  });

  xf86videoopenchrome = prev.xf86videoopenchrome.overrideAttrs (attrs: {
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

  xf86videoxgi = prev.xf86videoxgi.overrideAttrs (attrs: {
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

  xfd = addMainProgram prev.xfd { };
  xfontsel = addMainProgram prev.xfontsel { };
  xfs = addMainProgram prev.xfs { };
  xfsinfo = addMainProgram prev.xfsinfo { };
  xgamma = addMainProgram prev.xgamma { };
  xgc = addMainProgram prev.xgc { };
  xhost = addMainProgram prev.xhost { };
  xinput = addMainProgram prev.xinput { };
  xkbevd = addMainProgram prev.xkbevd { };
  xkbprint = addMainProgram prev.xkbprint { };
  xkill = addMainProgram prev.xkill { };
  xload = addMainProgram prev.xload { };
  xlsatoms = addMainProgram prev.xlsatoms { };
  xlsclients = addMainProgram prev.xlsclients { };
  xmag = addMainProgram prev.xmag { };
  xmessage = addMainProgram prev.xmessage { };
  xmodmap = addMainProgram prev.xmodmap { };
  xmore = addMainProgram prev.xmore { };

  xorgcffiles = prev.xorgcffiles.overrideAttrs (attrs: {
    postInstall = lib.optionalString stdenv.isDarwin ''
      substituteInPlace $out/lib/X11/config/darwin.cf --replace "/usr/bin/" ""
    '';
  });

  xorgdocs = prev.xorgdocs.overrideAttrs (attrs: {
    # This makes the man pages discoverable by the default man,
    # since it looks for packages in $PATH
    postInstall = "mkdir $out/bin";
  });

  xpr = addMainProgram prev.xpr { };
  xprop = addMainProgram prev.xprop { };

  xrdb = prev.xrdb.overrideAttrs (attrs: {
    configureFlags = [ "--with-cpp=${mcpp}/bin/mcpp" ];
    meta = attrs.meta // {
      mainProgram = "xrdb";
    };
  });

  sessreg = prev.sessreg.overrideAttrs (attrs: {
    preBuild = "sed -i 's|gcc -E|gcc -E -P|' man/Makefile";
    meta = attrs.meta // {
      mainProgram = "sessreg";
    };
  });

  xrandr = prev.xrandr.overrideAttrs (attrs: {
    postInstall = ''
      rm $out/bin/xkeystone
    '';
    meta = attrs.meta // {
      mainProgram = "xrandr";
    };
  });

  xrefresh = addMainProgram prev.xrefresh { };
  xset = addMainProgram prev.xset { };
  xsetroot = addMainProgram prev.xsetroot { };
  xsm = addMainProgram prev.xsm { };
  xstdcmap = addMainProgram prev.xstdcmap { };
  xwd = addMainProgram prev.xwd { };
  xwininfo = addMainProgram prev.xwininfo { };
  xwud = addMainProgram prev.xwud { };
}
