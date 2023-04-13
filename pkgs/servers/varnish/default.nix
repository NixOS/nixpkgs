{ lib, stdenv, fetchurl, fetchpatch, pcre, pcre2, jemalloc, libunwind, libxslt, groff, ncurses, pkg-config, readline, libedit
, coreutils, python3, makeWrapper, nixosTests }:

let
  common = { version, hash, extraNativeBuildInputs ? [] }:
    stdenv.mkDerivation rec {
      pname = "varnish";
      inherit version;

      src = fetchurl {
        url = "https://varnish-cache.org/_downloads/${pname}-${version}.tgz";
        inherit hash;
      };

      nativeBuildInputs = with python3.pkgs; [ pkg-config docutils sphinx makeWrapper];
      buildInputs = [
        libxslt groff ncurses readline libedit python3
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

      outputs = [ "out" "dev" "man" ];

      passthru = {
        python = python3;
        tests = nixosTests."varnish${builtins.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor version)}";
      };

      meta = with lib; {
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = "https://www.varnish-cache.org";
        license = licenses.bsd2;
        maintainers = with maintainers; [ ajs124 ];
        platforms = platforms.unix;
      };
    };
in
{
  # EOL TBA
  varnish60 = common {
    version = "6.0.11";
    hash = "sha256-UVkA2+tH/9MOs5BlyuAzFnmD7Pm9A6lDWic2B+HRKNs=";
  };
  # EOL 2023-09-15
  varnish72 = common {
    version = "7.2.1";
    hash = "sha256-TZN9FyCo7BnFM/ly2TA6HJiJt7/KdDeJOuXCfPIEqUA=";
  };
}
