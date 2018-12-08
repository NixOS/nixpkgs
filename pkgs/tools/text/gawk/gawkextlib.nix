{ stdenv, fetchgit, writeText, pkgconfig, autoreconfHook, autoconf, automake
, libtool, texinfo, gettext, gawk, rapidjson, gd, shapelib, libharu, lmdb, gmp
, glibcLocales, mpfr, more, postgresql, hiredis, expat, tre, makeWrapper
}:

let
  buildGawkextlibExtension = extension: extraDeps:
    stdenv.mkDerivation rec {
      name = "gawkextlib-${extension}-2019-11-21";

      src = fetchgit {
        url = "git://git.code.sf.net/p/gawkextlib/code";
        rev = "f70f10da2804e4fd0a0bac57736e9c1cf21e345d";
        sha256 = "sha256-M3bBjOp8OrrOosEDScEgJUEFJPYApaC/do3QYRP6DmU=";
      };

      nativeBuildInputs =
        [ autoconf automake libtool autoreconfHook pkgconfig texinfo gettext ];

      buildInputs = [
        gawk
        gawkextlib
        #rapidjson gd shapelib libharu
        #lmdb gmp mpfr postgresql hiredis expat tre
      ] ++ extraDeps;
      configureFlags = [
        "--with-gawkextlib=${gawkextlib}/lib/"
        "LDFLAGS=-L${gawkextlib}/lib"
      ];

      postPatch = ''
        cd ${extension}
      '';
      installPhase = ''
        mkdir -p $out/lib
        cp ./.libs/* $out/lib
        runHook postInstall
      '';

      # Needed for some tests
      preCheck = ''
        AWKLIBPATH=${gawk}/lib/gawk
      '';
      setupHook = writeText "setupHook.sh" ''
        export AWKLIBPATH="''${AWKLIBPATH-}''${AWKLIBPATH:+:}"@out@/lib
      '';

      doCheck = stdenv.isLinux;

      meta = with stdenv.lib; {
        homepage = "https://sourceforge.net/projects/gawkextlib/";
        description = "Dynamically loaded extension libraries for GNU AWK";
        longDescription = ''
          The gawkextlib project provides several extension libraries for
          gawk (GNU AWK), as well as libgawkextlib containing some APIs that
          are useful for building gawk extension libraries. These libraries
          enable gawk to process XML data, interact with a PostgreSQL
          database, use the GD graphics library, and perform unlimited
          precision MPFR calculations.
        '';
        license = licenses.gpl3Plus;
        platforms = platforms.unix;
        maintainers = with maintainers; [ tomberek ];
      };
    };
  gawkextlib = (buildGawkextlibExtension "lib" []).overrideAttrs (old: {
    configureFlags = null;
    buildInputs = [ gawk ];
    postInstall = ''
      cp ../lib/gawkextlib.h $out/lib/.
    '';
  });
in {

  # callPackage injects extra items into the root attrSet
  full = {
    inherit gawkextlib;

    abort       = buildGawkextlibExtension "abort"       [              ];
    aregex      = buildGawkextlibExtension "aregex"      [ tre          ];
    csv         = buildGawkextlibExtension "csv"         [              ];
    errno       = buildGawkextlibExtension "errno"       [              ];
    gd          = buildGawkextlibExtension "gd"          [ gd more      ];
    haru        = buildGawkextlibExtension "haru"        [ libharu      ];
    json        = buildGawkextlibExtension "json"        [ rapidjson    ];
    lmdb        = buildGawkextlibExtension "lmdb"        [ lmdb         ];
    mbs         = buildGawkextlibExtension "mbs"         [ glibcLocales ];
    mpfr        = buildGawkextlibExtension "mpfr"        [ gmp mpfr     ];
    nl_langinfo = buildGawkextlibExtension "nl_langinfo" [              ];
    pgsql       = buildGawkextlibExtension "pgsql"       [ postgresql   ];
    select      = buildGawkextlibExtension "select"      [ more         ];
    xml         = buildGawkextlibExtension "xml"         [ expat        ];
    timex       = buildGawkextlibExtension "timex"       [              ];

    redis = (buildGawkextlibExtension "redis" [ hiredis ]).overrideAttrs
      (old: {
        configureFlags = old.configureFlags
          ++ [ "--with-hiredis=${hiredis}/lib/" ];
      });
  };
}
