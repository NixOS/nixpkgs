{ lib, stdenv, fetchurl, fetchpatch, pcre, pcre2, jemalloc, libxslt, groff, ncurses, pkg-config, readline, libedit
, coreutils, python3, makeWrapper }:

let
  common = { version, hash, extraNativeBuildInputs ? [] }:
    stdenv.mkDerivation rec {
      pname = "varnish";
      inherit version;

      src = fetchurl {
        url = "https://varnish-cache.org/_downloads/${pname}-${version}.tgz";
        inherit hash;
      };

      passthru.python = python3;

      nativeBuildInputs = with python3.pkgs; [ pkg-config docutils sphinx makeWrapper];
      buildInputs = [
        libxslt groff ncurses readline libedit python3
      ]
      ++ lib.optional (lib.versionOlder version "7") pcre
      ++ lib.optional (lib.versionAtLeast version "7") pcre2
      ++ lib.optional stdenv.hostPlatform.isLinux jemalloc;

      buildFlags = [ "localstatedir=/var/spool" ];

      postPatch = ''
        substituteInPlace bin/varnishtest/vtc_main.c --replace /bin/rm "${coreutils}/bin/rm"
      '';

      postInstall = ''
        wrapProgram "$out/sbin/varnishd" --prefix PATH : "${lib.makeBinPath [ stdenv.cc ]}"
      '';

      # https://github.com/varnishcache/varnish-cache/issues/1875
      NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-fexcess-precision=standard";

      outputs = [ "out" "dev" "man" ];

      meta = with lib; {
        broken = stdenv.isDarwin;
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = "https://www.varnish-cache.org";
        license = licenses.bsd2;
        maintainers = with maintainers; [ ajs124 ];
        platforms = platforms.unix;
      };
    };
in
{
  varnish60 = common {
    version = "6.0.10";
    hash = "sha256-a4W/dI7jeaoI43UE+G6tS6fgzEDqsXI8CUv+Wh4HJus=";
  };
  varnish71 = common {
    version = "7.1.1";
    hash = "sha256-LK++JZDn1Yp7rIrZm+kuRA/k04raaBbdiDbyL6UToZA=";
  };
}
