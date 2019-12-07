{ stdenv, recurseIntoAttrs, fetchgit, writeText, pkgconfig, autoreconfHook,
autoconf, automake, libiconv, libtool, texinfo, gettext, gawk, rapidjson, gd,
shapelib, libharu, lmdb, gmp, glibcLocales, mpfr, more, postgresql, hiredis,
expat, tre, makeWrapper
}:

let
  buildGawkextlibExtension = extension: extraBuildInputs:
    stdenv.mkDerivation rec {
      pname = "gawkextlib-${extension}";
      version = "unstable-2019-11-21";

      src = fetchgit {
        url = "git://git.code.sf.net/p/gawkextlib/code";
        rev = "f70f10da2804e4fd0a0bac57736e9c1cf21e345d";
        sha256 = "0r8fz89n3l4dfszs1980yqj0ah95430lj0y1lb7blfkwxa6c2xik";
      };

      nativeBuildInputs =
        [ autoconf automake libtool autoreconfHook pkgconfig texinfo gettext ];

      buildInputs = [ gawk ] ++ extraBuildInputs;
      propagatedBuildInputs = [ gawkextlib ];

      configureFlags = [
        "--with-gawkextlib=${gawkextlib}/lib/"
        "LDFLAGS=-L${gawkextlib}/lib"
      ];

      postPatch = ''
        cd ${extension}
      '';
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib
        cp ./.libs/* $out/lib
        runHook postInstall
      '';

      setupHook = ./setup-hook.sh;
      inherit gawk;

      doCheck = stdenv.isLinux;
      checkInputs = [ more ];

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
    configureFlags = [];
    propagatedBuildInputs = [];
    postInstall = ''
      cp ../lib/gawkextlib.h $out/lib/.
    '';
  });
  libs = {
    abort       = buildGawkextlibExtension "abort"       [              ];
    aregex      = buildGawkextlibExtension "aregex"      [ tre          ];
    csv         = buildGawkextlibExtension "csv"         [              ];
    errno       = buildGawkextlibExtension "errno"       [              ];
    gd          = buildGawkextlibExtension "gd"          [ gd           ];
    haru        = buildGawkextlibExtension "haru"        [ libharu      ];
    json        = buildGawkextlibExtension "json"        [ rapidjson    ];
    lmdb        = buildGawkextlibExtension "lmdb"        [ lmdb         ];
    mbs         = buildGawkextlibExtension "mbs"         [ glibcLocales ];
    mpfr        = buildGawkextlibExtension "mpfr"        [ gmp mpfr     ];
    nl_langinfo = buildGawkextlibExtension "nl_langinfo" [              ];
    pgsql       = buildGawkextlibExtension "pgsql"       [ postgresql   ];
    redis       = buildGawkextlibExtension "redis"       [ hiredis      ];
    xml         = buildGawkextlibExtension "xml"         [ expat libiconv ];
    timex       = buildGawkextlibExtension "timex"       [              ];
    select      = buildGawkextlibExtension "select"      [              ];
  };
in recurseIntoAttrs (libs // {
  inherit gawkextlib;
  full = builtins.attrValues libs;
})
