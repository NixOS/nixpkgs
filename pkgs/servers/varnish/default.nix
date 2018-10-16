{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, libedit
, python2, makeWrapper }:

let
  common = { version, sha256, extraBuildInputs ? [] }:
    stdenv.mkDerivation rec {
      name = "varnish-${version}";

      src = fetchurl {
        url = "https://varnish-cache.org/_downloads/${name}.tgz";
        inherit sha256;
      };

      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [
        pcre libxslt groff ncurses readline python2 libedit
        python2.pkgs.docutils makeWrapper
      ] ++ extraBuildInputs;

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
    version = "4.1.10";
    sha256 = "08kwx0il6cqxsx3897042plh1yxjaanbaqjbspfl0xgvyvxk6j1n";
  };
  varnish5 = common {
    version = "5.2.1";
    sha256 = "1cqlj12m426c1lak1hr1fx5zcfsjjvka3hfirz47hvy1g2fjqidq";
  };
  varnish6 = common {
    version = "6.1.0";
    sha256 = "0zg2aqkg7a4zsjpxj0s7mphxv5f9xy279hjwln30h901k18r46qn";
    extraBuildInputs = [ python2.pkgs.sphinx ];
  };
}
