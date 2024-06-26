{
  lib,
  stdenv,
  fetchurl,
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
      env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-fexcess-precision=standard";

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
        maintainers = teams.helsinki-systems.members;
        platforms = platforms.unix;
      };
    };
in
{
  # EOL (LTS) TBA
  varnish60 = common {
    version = "6.0.13";
    hash = "sha256-DcpilfnGnUenIIWYxBU4XFkMZoY+vUK/6wijZ7eIqbo=";
  };
  # EOL 2024-09-15
  varnish74 = common {
    version = "7.4.3";
    hash = "sha256-655DUH+Dbu8uMoAtRt08+S7KPVR7pLZA/aWbQHzbG4g=";
  };
  # EOL 2025-03-15
  varnish75 = common {
    version = "7.5.0";
    hash = "sha256-/KYbmDE54arGHEVG0SoaOrmAfbsdgxRXHjFIyT/3K10=";
  };
}
