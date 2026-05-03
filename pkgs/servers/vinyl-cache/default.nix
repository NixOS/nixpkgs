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
  generic =
    {
      version,
      hash,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "vinyl-cache";
      inherit version;

      src = fetchurl {
        url = "https://vinyl-cache.org/downloads/${finalAttrs.pname}-${version}.tgz";
        inherit hash;
      };

      __structuredAttrs = true;
      strictDeps = true;

      nativeBuildInputs = [
        pkg-config
        python3.pkgs.docutils
        python3.pkgs.sphinx
        makeWrapper
      ];

      buildInputs = [
        libxslt
        groff
        ncurses
        readline
        libedit
        pcre2
        python3
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
        substituteInPlace bin/vinyltest/vtest2/src/vtc_main.c --replace-fail /bin/rm "${coreutils}/bin/rm"
      '';

      postConfigure = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        # prevent cache invalidation
        substituteInPlace bin/vinyld/Makefile \
          --replace-fail "vhp_hufdec.h: vhp_gen_hufdec" "vhp_hufdec.h:"

        ln -s "${buildPackages.vinyl.vhp_hufdec_h}" bin/vinyld/vhp_hufdec.h

        substituteInPlace bin/vinylstat/Makefile \
          --replace-fail "vinylstat_curses_help.c: vinylstat_help_gen" "vinylstat_curses_help.c:" \
          --replace-fail "./vinylstat_help_gen" "${buildPackages.vinyl}/bin/vinylstat_help_gen"

        # the docs execute lots of commands to gather options and flags
        substituteInPlace doc/Makefile \
          --replace-fail "SUBDIRS = graphviz sphinx" "SUBDIRS = graphviz"
        substituteInPlace Makefile \
          --replace-fail "include lib bin vmod etc doc man contrib" "include lib bin vmod etc doc contrib"
      '';

      postInstall = ''
        wrapProgram "$out/sbin/vinyld" --prefix PATH : "${lib.makeBinPath [ stdenv.cc ]}"
      ''
      + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        cp bin/vinyld/vhp_hufdec.h $vhp_hufdec_h
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
        tests = nixosTests."vinyl-cache_${lib.versions.major version}";
      };

      meta = {
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = "https://vinyl-cache.org";
        license = lib.licenses.bsd2;
        maintainers = [
          lib.maintainers.leona
          lib.maintainers.osnyx
        ];
        platforms = lib.platforms.unix;
        broken = stdenv.hostPlatform.isDarwin;
      };
    });
in
{
  # EOL 2027-03-16
  vinyl-cache_9 = generic {
    version = "9.0.0";
    hash = "sha256-l0DCEMKndifVD9CtbHWdw8oJT8tOZVW6VfynHPSDvRc=";
  };
}
