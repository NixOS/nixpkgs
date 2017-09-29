{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, libedit
, python, pythonPackages, makeWrapper }:

stdenv.mkDerivation rec {
  version = "5.1.3";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "0km50hzjzi1kq85lr3hq519nrp261wb91ixq48vhyd41llycjfbl";
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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
