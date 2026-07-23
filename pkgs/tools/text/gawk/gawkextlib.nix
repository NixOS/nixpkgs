{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  autoreconfHook,
  autoconf,
  automake,
  libiconv,
  libtool,
  texinfo,
  gettext,
  gawk,
  rapidjson,
  gd,
  libharu,
  lmdb,
  gmp,
  glibcLocales,
  mpfr,
  more,
  libpq,
  hiredis,
  expat,
  tre,
}:

let
  buildExtension = lib.makeOverridable (
    {
      name,
      gawkextlib,
      extraBuildInputs ? [ ],
      doCheck ? true,
      patches ? [ ],
      extraPostPatch ? "",
      env ? { },
      broken ? null,
    }:
    let
      is_extension = gawkextlib != null;
    in
    stdenv.mkDerivation rec {
      pname = "gawkextlib-${name}";
      version = "unstable-2022-10-20";

      src = fetchgit {
        url = "git://git.code.sf.net/p/gawkextlib/code";
        rev = "f6c75b4ac1e0cd8d70c2f6c7a8d58b4d94cfde97";
        sha256 = "sha256-0p3CrQ3TBl7UcveZytK/9rkAzn69RRM2GwY2eCeqlkg=";
      };

      inherit patches;

      postPatch = ''
        cd ${name}
      ''
      + extraPostPatch;

      nativeBuildInputs = [
        autoconf
        automake
        libtool
        autoreconfHook
        pkg-config
        texinfo
        gettext
      ];

      buildInputs = [ gawk ] ++ extraBuildInputs;
      propagatedBuildInputs = lib.optional is_extension gawkextlib;

      setupHook = if is_extension then ./setup-hook.sh else null;
      inherit gawk;

      inherit env;

      inherit doCheck;
      nativeCheckInputs = [ more ];

      meta = {
        homepage = "https://sourceforge.net/projects/gawkextlib/";
        description = "Dynamically loaded extension libraries for GNU AWK";
        mainProgram = "xmlgawk";
        longDescription = ''
          The gawkextlib project provides several extension libraries for
          gawk (GNU AWK), as well as libgawkextlib containing some APIs that
          are useful for building gawk extension libraries. These libraries
          enable gawk to process XML data, interact with a PostgreSQL
          database, use the GD graphics library, and perform unlimited
          precision MPFR calculations.
        '';
        license = lib.licenses.gpl3Plus;
        platforms = lib.platforms.unix;
        maintainers = with lib.maintainers; [ tomberek ];
      }
      // lib.optionalAttrs (broken != null) { inherit broken; };
    }
  );
  gawkextlib = buildExtension {
    gawkextlib = null;
    name = "lib";
  };
  libs = {
    abort = buildExtension {
      inherit gawkextlib;
      name = "abort";
    };
    aregex = buildExtension {
      inherit gawkextlib;
      name = "aregex";
      extraBuildInputs = [ tre ];
    };
    csv = buildExtension {
      inherit gawkextlib;
      name = "csv";
    };
    errno = buildExtension {
      inherit gawkextlib;
      name = "errno";
      extraPostPatch = ''
        substituteInPlace Makefile.am --replace-fail 'cpp -M' '${stdenv.cc.targetPrefix}cpp -M'
      '';
    };
    gd = buildExtension {
      inherit gawkextlib;
      name = "gd";
      extraBuildInputs = [ gd ];
      # GCC 14 makes this an error by default, remove when fixed upstream
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    };
    haru = buildExtension {
      inherit gawkextlib;
      name = "haru";
      extraBuildInputs = [ libharu ];
      patches = [
        # Renames references to two identifiers with typos that libharu fixed in 2.4.4
        # https://github.com/libharu/libharu/commit/88271b73c68c521a49a15e3555ef00395aa40810
        ./fix-typos-corrected-in-libharu-2.4.4.patch
      ];
      # GCC 14 makes this an error by default, remove when fixed upstream
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    };
    json = buildExtension {
      inherit gawkextlib;
      name = "json";
      extraBuildInputs = [ rapidjson ];
    };
    lmdb = buildExtension {
      inherit gawkextlib;
      name = "lmdb";
      extraPostPatch = ''
        substituteInPlace Makefile.am --replace-fail 'cpp -M' '${stdenv.cc.targetPrefix}cpp -M'
      '';
      extraBuildInputs = [ lmdb ];
      #  mdb_env_open(env, /dev/null)
      #! No such device
      #  mdb_env_open(env, /dev/null)
      #! Operation not supported by device
      doCheck = !stdenv.hostPlatform.isDarwin;
    };
    mbs = buildExtension {
      inherit gawkextlib;
      name = "mbs";
      extraBuildInputs = [ glibcLocales ];
      #! "spät": length: 5, mbs_length: 6, wcswidth: 4
      doCheck = !stdenv.hostPlatform.isDarwin;
    };
    mpfr = buildExtension {
      inherit gawkextlib;
      name = "mpfr";
      extraBuildInputs = [
        gmp
        mpfr
      ];
    };
    nl_langinfo = buildExtension {
      inherit gawkextlib;
      name = "nl_langinfo";
    };
    pgsql = buildExtension {
      inherit gawkextlib;
      name = "pgsql";
      extraBuildInputs = [ libpq ];
    };
    redis = buildExtension {
      inherit gawkextlib;
      name = "redis";
      extraBuildInputs = [ hiredis ];
    };
    select = buildExtension {
      inherit gawkextlib;
      name = "select";
      extraPostPatch = ''
        substituteInPlace Makefile.am --replace-fail 'cpp -M' '${stdenv.cc.targetPrefix}cpp -M'
      '';
    };
    timex = buildExtension {
      inherit gawkextlib;
      name = "timex";
    };
    xml = buildExtension {
      inherit gawkextlib;
      name = "xml";
      extraBuildInputs = [
        expat
        libiconv
      ];
      # gawk: xmlbase:14: fatal: load_ext: cannot open library `../.libs/xml.so`
      broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    };
  };
in
lib.recurseIntoAttrs (
  libs
  // {
    inherit gawkextlib buildExtension;
    full = builtins.attrValues libs;
  }
)
