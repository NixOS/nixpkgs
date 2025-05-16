{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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
      patches ? [ ],
      extraNativeBuildInputs ? [ ],
    }:
    stdenv.mkDerivation rec {
      pname = "varnish";
      inherit version;

      src = fetchurl {
        url = "https://varnish-cache.org/_downloads/${pname}-${version}.tgz";
        inherit hash;
      };

      inherit patches;

      nativeBuildInputs = with python3.pkgs; [
        pkg-config
        docutils
        sphinx
        makeWrapper
      ];
      buildInputs =
        [
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

      buildFlags = [ "localstatedir=/var/spool" ];

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
        maintainers = [ ];
        platforms = platforms.unix;
      };
    };
in
{
  # EOL (LTS) TBA
  varnish60 = common {
    version = "6.0.14";
    hash = "sha256-tZlBf3ppntxxYSufEJ86ot6ujvnbfIyZOu9B3kDJ72k=";
  };
  # EOL 2025-03-15
  varnish75 = common {
    version = "7.5.0";
    hash = "sha256-/KYbmDE54arGHEVG0SoaOrmAfbsdgxRXHjFIyT/3K10=";
    patches = [
      (fetchpatch {
        name = "CVE-2025-30346.patch";
        url = "https://github.com/varnishcache/varnish-cache/commit/a9640a13276048815cc51a12cda2603f4d4444e4.patch";
        hash = "sha256-hzm09GMB7WLGp6zyqgMkxm9tJwUT9bRnEAPrX47v3e8=";
      })
    ];
  };
  # EOL 2025-09-15
  varnish76 = common {
    version = "7.6.3";
    hash = "sha256-JwP2Ru6JO3iEa8t91LlrKPkSX7iq9+ilaS2k3+SEVGc=";
  };
  # EOL 2026-03-15
  varnish77 = common {
    version = "7.7.1";
    hash = "sha256-TAbFyZaApCm3KTT5/VE5Y/fhuoVTszyn7BLIWlwrdRo=";
  };
}
