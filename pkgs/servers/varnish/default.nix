{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, libedit
, python, pythonPackages, makeWrapper }:

let
  common = { version, sha256 }:
    stdenv.mkDerivation rec {
      name = "varnish-${version}";

      src = fetchurl {
        url = "http://varnish-cache.org/_downloads/${name}.tgz";
        inherit sha256;
      };

      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [
        pcre libxslt groff ncurses readline python libedit
        pythonPackages.docutils makeWrapper
      ];

      buildFlags = "localstatedir=/var/spool";

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
        maintainers = with maintainers; [ garbas fpletz ];
        platforms = platforms.unix;
      };
    };
in
{
  varnish4 = common {
    version = "4.1.9";
    sha256 = "11zwyasz2fn9qxc87r175wb5ba7388sd79mlygjmqn3yv2m89n12";
  };
  varnish5 = common {
    version = "5.2.1";
    sha256 = "1cqlj12m426c1lak1hr1fx5zcfsjjvka3hfirz47hvy1g2fjqidq";
  };
  varnish6 = common {
    version = "6.0.0";
    sha256 = "1vhbdch33m6ig4ijy57zvrramhs9n7cba85wd8rizgxjjnf87cn7";
  };
}
