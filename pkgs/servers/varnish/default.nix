{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
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
      extraNativeBuildInputs ? [ ],
    }:
    stdenv.mkDerivation rec {
      pname = "varnish";
      inherit version;

      src = fetchurl {
        url = "https://varnish-cache.org/_downloads/${pname}-${version}.tgz";
        inherit hash;
      };

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
        substituteInPlace bin/varnishtest/vtc_main.c --replace /bin/rm "${coreutils}/bin/rm"
      '';

      postInstall = ''
        wrapProgram "$out/sbin/varnishd" --prefix PATH : "${lib.makeBinPath [ stdenv.cc ]}"
      '';

      # https://github.com/varnishcache/varnish-cache/issues/1875
      env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isi686 "-fexcess-precision=standard";

      outputs = [
        "out"
        "dev"
        "man"
      ];

      passthru = {
        python = python3;
        tests =
          nixosTests."varnish${builtins.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor version)}";
      };

      meta = with lib; {
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = "https://www.varnish-cache.org";
        license = licenses.bsd2;
        teams = [ lib.teams.flyingcircus ];
        platforms = platforms.unix;
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
