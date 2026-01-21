{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  buildPackages,
  pcre,
  pcre2,
  jemalloc,
  libunwind,
  libxslt,
  groff,
  ncurses,
  pkg-config,
  readline,
  libedit,
  coreutils,
  python3,
  makeWrapper,
  nixosTests,
}:

let
  common =
    {
      version,
      hash,
    }:
    stdenv.mkDerivation rec {
      pname = "varnish";
      inherit version;

      src = fetchurl {
        url = "https://varnish-cache.org/_downloads/${pname}-${version}.tgz";
        inherit hash;
      };

      strictDeps = true;

      nativeBuildInputs = with python3.pkgs; [
        pkg-config
        docutils
        sphinx
        makeWrapper
      ];

      buildInputs = [
        libxslt
        groff
        ncurses
        readline
        libedit
        python3
      ]
      ++ lib.optional (lib.versionOlder version "7") pcre
      ++ lib.optional (lib.versionAtLeast version "7") pcre2
      ++ lib.optional stdenv.hostPlatform.isDarwin libunwind
      ++ lib.optional stdenv.hostPlatform.isLinux jemalloc;

      configureFlags = [
        # the checks behind those to not work when doing cross but for simplicity we always define them
        "ac_cv_have_tcp_fastopen=yes"
        "ac_cv_have_tcp_keep=yes"
        "ac_cv_have_working_close_range=yes"
        "PYTHON=${buildPackages.python3.interpreter}"
      ];

      buildFlags = [ "localstatedir=/var/run" ];

      patches =
        lib.optionals (stdenv.isDarwin && lib.versionAtLeast version "7.7") [
          # Fix VMOD section attribute on macOS
          # Unreleased commit on master
          (fetchpatch2 {
            url = "https://github.com/varnishcache/varnish-cache/commit/a95399f5b9eda1bfdba6ee6406c30a1ed0720167.patch";
            hash = "sha256-T7DIkmnq0O+Cr9DTJS4/rOtg3J6PloUo8jHMWoUZYYk=";
          })
          # Fix endian.h compatibility on macOS
          # PR: https://github.com/varnishcache/varnish-cache/pull/4339
          ./patches/0001-fix-endian-h-compatibility-on-macos.patch
        ]
        ++ lib.optionals (stdenv.isDarwin && lib.versionOlder version "7.6") [
          # Fix duplicate OS_CODE definitions on macOS
          # PR: https://github.com/varnishcache/varnish-cache/pull/4347
          ./patches/0002-fix-duplicate-os-code-definitions-on-macos.patch
        ];

      postPatch = ''
        substituteInPlace bin/varnishtest/vtc_main.c --replace-fail /bin/rm "${coreutils}/bin/rm"
      '';

      postConfigure = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        # prevent cache invalidation
        substituteInPlace bin/varnishd/Makefile \
          --replace-fail "vhp_hufdec.h: vhp_gen_hufdec" "vhp_hufdec.h:"

        ln -s "${buildPackages.varnish.vhp_hufdec_h}" bin/varnishd/vhp_hufdec.h

        substituteInPlace bin/varnishstat/Makefile \
          --replace-fail "varnishstat_curses_help.c: varnishstat_help_gen" "varnishstat_curses_help.c:" \
          --replace-fail "./varnishstat_help_gen" "${buildPackages.varnish}/bin/varnishstat_help_gen"

        # the docs execute lots of commands to gather options and flags
        substituteInPlace doc/Makefile \
          --replace-fail "SUBDIRS = graphviz sphinx" "SUBDIRS = graphviz"
        substituteInPlace Makefile \
          --replace-fail "include lib bin vmod etc doc man contrib" "include lib bin vmod etc doc contrib"
      '';

      postInstall = ''
        wrapProgram "$out/sbin/varnishd" --prefix PATH : "${lib.makeBinPath [ stdenv.cc ]}"
      ''
      + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        cp bin/varnishd/vhp_hufdec.h $vhp_hufdec_h
      '';

      # https://github.com/varnishcache/varnish-cache/issues/1875
      env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isi686 "-fexcess-precision=standard";

      outputs = [
        "out"
        "dev"
      ]
      ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
        "man"
        "vhp_hufdec_h" # only used for cross compilation
      ];

      passthru = {
        python = python3;
        tests =
          nixosTests."varnish${builtins.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor version)}";
      };

      meta = {
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = "https://www.varnish-cache.org";
        license = lib.licenses.bsd2;
        maintainers = [
          lib.maintainers.leona
          lib.maintainers.osnyx
        ];
        platforms = lib.platforms.unix;
      };
    };
in
{
  # EOL (LTS) TBA
  varnish60 = common {
    version = "6.0.16";
    hash = "sha256-ZVJxDHp9LburwlJ1LCR5CKPRaSbNixiEch/l3ZP0QyQ=";
  };
  # EOL 2026-03-15
  varnish77 = common {
    version = "7.7.3";
    hash = "sha256-6W7q/Ez+KlWO0vtU8eIr46PZlfRvjADaVF1YOq74AjY=";
  };
}
