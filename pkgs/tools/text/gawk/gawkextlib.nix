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
      version ? "0",
      broken ? null,
    }:
    let
      is_extension = gawkextlib != null;
    in
    stdenv.mkDerivation {
      pname = "gawkextlib-${name}";
      version = "${version}-unstable-2024-01-21";

      src = fetchgit {
        url = "git://git.code.sf.net/p/gawkextlib/code";
        rev = "9f5761589277bc1270ff671aa3afcca5bbc45e57";
        hash = "sha256-NxkgVkA9YHhHOb2weQ+veVk8/VD0YpaDPwK2cGkQRKQ=";
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
      version = "1.0.1";
    };
    aregex = buildExtension {
      inherit gawkextlib;
      name = "aregex";
      version = "1.1.0";
      extraBuildInputs = [ tre ];
    };
    csv = buildExtension {
      inherit gawkextlib;
      name = "csv";
      version = "1.0.0";
    };
    errno = buildExtension {
      inherit gawkextlib;
      name = "errno";
      version = "1.1.1";
    };
    gd = buildExtension {
      inherit gawkextlib;
      name = "gd";
      version = "1.0.3";
      extraBuildInputs = [ gd ];
      # GCC 14 makes this an error by default, remove when fixed upstream
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    };
    haru = buildExtension {
      inherit gawkextlib;
      name = "haru";
      version = "1.0.2";
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
      version = "2.1.0";
      extraBuildInputs = [ rapidjson ];
    };
    lmdb = buildExtension {
      inherit gawkextlib;
      name = "lmdb";
      version = "1.1.3";
      extraBuildInputs = [ lmdb ];
    };
    mbs = buildExtension {
      inherit gawkextlib;
      name = "mbs";
      version = "1.0.0";
      extraBuildInputs = [ glibcLocales ];
      #! "spät": length: 5, mbs_length: 6, wcswidth: 4
      doCheck = !stdenv.hostPlatform.isDarwin;
    };
    mpfr = buildExtension {
      inherit gawkextlib;
      name = "mpfr";
      version = "1.1.0";
      extraBuildInputs = [
        gmp
        mpfr
      ];
    };
    nl_langinfo = buildExtension {
      inherit gawkextlib;
      name = "nl_langinfo";
      version = "1.1.0";
    };
    pgsql = buildExtension {
      inherit gawkextlib;
      name = "pgsql";
      version = "1.1.2";
      extraBuildInputs = [ libpq ];
    };
    reclen = buildExtension {
      inherit gawkextlib;
      name = "reclen";
      version = "1.0.1";
    };
    redis = buildExtension {
      inherit gawkextlib;
      name = "redis";
      version = "1.7.4";
      extraBuildInputs = [ hiredis ];
    };
    select = buildExtension {
      inherit gawkextlib;
      name = "select";
      version = "1.1.4";
    };
    xml = buildExtension {
      inherit gawkextlib;
      name = "xml";
      version = "1.1.2";
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
