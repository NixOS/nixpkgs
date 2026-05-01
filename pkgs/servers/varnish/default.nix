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
        url = "https://vinyl-cache.org/_downloads/${pname}-${version}.tgz";
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
        lib.optionals
          (stdenv.isDarwin && lib.versionAtLeast version "7.7" && lib.versionOlder version "8.0")
          [
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

      postPatch =
        lib.optionalString (lib.versionOlder version "8.0") ''
          substituteInPlace bin/varnishtest/vtc_main.c --replace /bin/rm "${coreutils}/bin/rm"
        ''
        + lib.optionalString (lib.versionAtLeast version "8.0") ''
          substituteInPlace bin/varnishtest/vtest2/src/vtc_main.c --replace-fail /bin/rm "${coreutils}/bin/rm"
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

      meta = {
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = "https://www.varnish-cache.org";
        license = lib.licenses.bsd2;
        teams = [ lib.teams.flyingcircus ];
        platforms = lib.platforms.unix;
        knownVulnerabilities = lib.optionals (lib.versions.major version == "7") [
          "VSV00018: https://vinyl-cache.org/security/VSV00018.html"
        ];
        broken = stdenv.isDarwin && version == "8.0.1"; # https://github.com/NixOS/nixpkgs/issues/495368
      };
    };
in
{
  # EOL (LTS) TBA
  varnish60 = common {
    version = "6.0.17";
    hash = "sha256-CVmHd1hCDFE/WIZqjc1TfX1O2RqFetdNSO4ihmXoL5k=";
  };
  # EOL 2026-03-15
  varnish77 = common {
    version = "7.7.3";
    hash = "sha256-6W7q/Ez+KlWO0vtU8eIr46PZlfRvjADaVF1YOq74AjY=";
  };
  # EOL 2026-09-15
  varnish80 = common {
    version = "8.0.1";
    hash = "sha256-n1oi1YrNvqw3GhY9683TYSG+XuS8hKoYfrfNDDGP5oI=";
  };
}
