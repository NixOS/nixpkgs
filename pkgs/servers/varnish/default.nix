{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, libedit
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

      nativeBuildInputs = with python3.pkgs; [ pkgconfig docutils sphinx ];
      buildInputs = [
        pcre libxslt groff ncurses readline libedit makeWrapper python3
      ];

      buildFlags = [ "localstatedir=/var/spool" ];

      postInstall = ''
        wrapProgram "$out/sbin/varnishd" --prefix PATH : "${stdenv.lib.makeBinPath [ stdenv.cc ]}"
      '';

      # https://github.com/varnishcache/varnish-cache/issues/1875
      NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isi686 "-fexcess-precision=standard";

      outputs = [ "out" "dev" "man" ];

      meta = with stdenv.lib; {
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = https://www.varnish-cache.org;
        license = licenses.bsd2;
        maintainers = with maintainers; [ fpletz ];
        platforms = platforms.unix;
      };
    };
in
{
  varnish60 = common {
    version = "6.0.5";
    sha256 = "11aw202s7zdp5qp66hii5nhgm2jk0d86pila7gqrnjgc7x8fs8a0";
  };
  varnish62 = common {
    version = "6.2.2";
    sha256 = "10s3qdvb95pkwp3wxndrigb892h0109yqr8dw4smrhfi0knhnfk5";
  };
  varnish63 = common {
    version = "6.3.1";
    sha256 = "0xa14pd68zpi5hxcax3arl14rcmh5d1cdwa8gv4l5f23mmynr8ni";
  };
}
