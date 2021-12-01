{ lib, stdenv, fetchurl, fetchpatch, pcre, pcre2, libxslt, groff, ncurses, pkg-config, readline, libedit, coreutils
, python3, makeWrapper }:

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
      ++ lib.optional (lib.versionAtLeast version "7") pcre2;

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
    version = "6.0.9";
    sha256 = "1g0pwyckc0xh6ag6wj082x9wn4q6p6krjgc16fkw1arl71c18wsh";
  };
  varnish70 = (common {
    version = "7.0.1";
    sha256 = "0q265fzarz5530g8lasvfpgks8z1kq1yh7rn88bn2qfly3pmpry4";
  }).overrideAttrs (oA: {
    patches = [
      (fetchpatch {
        url = "https://github.com/varnishcache/varnish-cache/commit/20e007a5b17c1f68f70ab42080de384f9e192900.patch";
        sha256 = "0vvihbjknb0skdv2ksn2lz89pwmn4f2rjmb6q65cvgnnjfj46s82";
      })
    ];
  });
}
