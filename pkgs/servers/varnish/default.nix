{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, python
, pythonPackages }:
let
  # This flag needs to be set during configure *and* build. It's mixed into
  # another statedir compile-time constant.
  flags = "localstatedir=/var/spool";
in stdenv.mkDerivation rec {
  version = "4.0.3";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "01l2iypajkdanxpbvzfxm6vs4jay4dgw7lmchqidnivz15sa3fcl";
  };

  buildInputs = [ pcre libxslt groff ncurses pkgconfig readline python
    pythonPackages.docutils];

  # Comment out a rule which attempts to write to /var.
  postPatch = ''
    substituteInPlace Makefile.in --replace '$(install_sh)' 'true #'
  '';

  configureFlags = flags;
  buildFlags = flags;

  meta = {
    description = "Web application accelerator also known as a caching HTTP reverse proxy";
    homepage = "https://www.varnish-cache.org";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
  };
}
