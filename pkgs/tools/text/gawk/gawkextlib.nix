<<<<<<< HEAD
{ lib, stdenv, recurseIntoAttrs, fetchgit, pkg-config, autoreconfHook
, autoconf, automake, libiconv, libtool, texinfo, gettext, gawk, rapidjson, gd
, libharu, lmdb, gmp, glibcLocales, mpfr, more, postgresql, hiredis
, expat, tre }:
=======
{ lib, stdenv, recurseIntoAttrs, fetchgit, writeText, pkg-config, autoreconfHook
, autoconf, automake, libiconv, libtool, texinfo, gettext, gawk, rapidjson, gd
, shapelib, libharu, lmdb, gmp, glibcLocales, mpfr, more, postgresql, hiredis
, expat, tre, makeWrapper }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  buildExtension = lib.makeOverridable
    ({ name, gawkextlib, extraBuildInputs ? [ ], doCheck ? true }:
      let is_extension = gawkextlib != null;
      in stdenv.mkDerivation rec {
        pname = "gawkextlib-${name}";
<<<<<<< HEAD
        version = "unstable-2022-10-20";

        src = fetchgit {
          url = "git://git.code.sf.net/p/gawkextlib/code";
          rev = "f6c75b4ac1e0cd8d70c2f6c7a8d58b4d94cfde97";
          sha256 = "sha256-0p3CrQ3TBl7UcveZytK/9rkAzn69RRM2GwY2eCeqlkg=";
=======
        version = "unstable-2019-11-21";

        src = fetchgit {
          url = "git://git.code.sf.net/p/gawkextlib/code";
          rev = "f70f10da2804e4fd0a0bac57736e9c1cf21e345d";
          sha256 = "0r8fz89n3l4dfszs1980yqj0ah95430lj0y1lb7blfkwxa6c2xik";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };

        postPatch = ''
          cd ${name}
        '';

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

        inherit doCheck;
        nativeCheckInputs = [ more ];

        meta = with lib; {
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
      });
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
    };
    gd = buildExtension {
      inherit gawkextlib;
      name = "gd";
      extraBuildInputs = [ gd ];
    };
<<<<<<< HEAD
    # Build has been broken: https://github.com/NixOS/nixpkgs/issues/191072
    # haru = buildExtension {
    #   inherit gawkextlib;
    #   name = "haru";
    #   extraBuildInputs = [ libharu ];
    # };
=======
    haru = buildExtension {
      inherit gawkextlib;
      name = "haru";
      extraBuildInputs = [ libharu ];
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    json = buildExtension {
      inherit gawkextlib;
      name = "json";
      extraBuildInputs = [ rapidjson ];
    };
    lmdb = buildExtension {
      inherit gawkextlib;
      name = "lmdb";
      extraBuildInputs = [ lmdb ];
      #  mdb_env_open(env, /dev/null)
      #! No such device
      #  mdb_env_open(env, /dev/null)
      #! Operation not supported by device
      doCheck = !stdenv.isDarwin;
    };
    mbs = buildExtension {
      inherit gawkextlib;
      name = "mbs";
      extraBuildInputs = [ glibcLocales ];
      #! "spät": length: 5, mbs_length: 6, wcswidth: 4
      doCheck = !stdenv.isDarwin;
    };
    mpfr = buildExtension {
      inherit gawkextlib;
      name = "mpfr";
      extraBuildInputs = [ gmp mpfr ];
    };
    nl_langinfo = buildExtension {
      inherit gawkextlib;
      name = "nl_langinfo";
    };
    pgsql = buildExtension {
      inherit gawkextlib;
      name = "pgsql";
      extraBuildInputs = [ postgresql ];
    };
    redis = buildExtension {
      inherit gawkextlib;
      name = "redis";
      extraBuildInputs = [ hiredis ];
    };
    select = buildExtension {
      inherit gawkextlib;
      name = "select";
    };
    timex = buildExtension {
      inherit gawkextlib;
      name = "timex";
    };
    xml = buildExtension {
      inherit gawkextlib;
      name = "xml";
      extraBuildInputs = [ expat libiconv ];
    };
  };
in recurseIntoAttrs (libs // {
  inherit gawkextlib buildExtension;
  full = builtins.attrValues libs;
})
