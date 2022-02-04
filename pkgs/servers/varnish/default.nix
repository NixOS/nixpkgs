{ lib, stdenv, fetchurl, fetchpatch, pcre, pcre2, jemalloc, libxslt, groff, ncurses, pkg-config, readline, libedit
, coreutils, python3, makeWrapper }:

let
  common = { version, sha256, extraNativeBuildInputs ? [] }:
    stdenv.mkDerivation rec {
      pname = "varnish";
      inherit version;

      src = fetchurl {
        url = "https://varnish-cache.org/_downloads/${pname}-${version}.tgz";
        inherit sha256;
      };

      passthru.python = python3;

      nativeBuildInputs = with python3.pkgs; [ pkg-config docutils sphinx ];
      buildInputs = [
        libxslt groff ncurses readline libedit makeWrapper python3
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
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = "https://www.varnish-cache.org";
        license = licenses.bsd2;
        maintainers = with maintainers; [ fpletz ];
        platforms = platforms.unix;
      };
    };
in
{
  varnish60 = common {
    version = "6.0.10";
    sha256 = "1sr60wg5mzjb14y75cga836f19sbmmpgh13mwc4alyg3irsbz1bb";
  };
  varnish70 = (common {
    version = "7.0.2";
    sha256 = "0q9z1iilqwbh5flfy9pl18kxv0yjs5z91c4j81z5pgyjd9d4jjjj";
  }).overrideAttrs (oA: {
    patches = [
      (fetchpatch {
        url = "https://github.com/varnishcache/varnish-cache/commit/20e007a5b17c1f68f70ab42080de384f9e192900.patch";
        sha256 = "0vvihbjknb0skdv2ksn2lz89pwmn4f2rjmb6q65cvgnnjfj46s82";
      })
    ];
  });
}
