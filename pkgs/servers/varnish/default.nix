{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
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
        url = "https://vinyl-cache.org/_downloads/${pname}-${version}.tgz";
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
        pcre2
      ]
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

      postPatch = ''
        substituteInPlace bin/varnishtest/vtest2/src/vtc_main.c --replace-fail /bin/rm "${coreutils}/bin/rm"
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
        broken = stdenv.hostPlatform.isDarwin && version == "8.0.1"; # https://github.com/NixOS/nixpkgs/issues/495368
      };
    };
in
{
  # EOL 2026-09-15
  varnish80 = common {
    version = "8.0.2";
    hash = "sha256-yGCDuFBGPBiJmCmQncAs5miLKfyoCym6+PbixW6tMI8=";
  };
}
