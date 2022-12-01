{ lib, stdenv, fetchurl, pcre, libxcrypt }:

stdenv.mkDerivation {
  pname = "leafnode";
  version = "2.0.0.alpha20121101a.12";

  src = fetchurl {
    url = "http://home.pages.de/~mandree/leafnode/beta/leafnode-2.0.0.alpha20121101a.tar.bz2";
    sha256 = "096w4gxj08m3vwmyv4sxpmbl8dn6mzqfmrhc32jgyca6qzlrdin8";
  };

  configureFlags = [ "--enable-runas-user=nobody" ];

  prePatch = ''
    substituteInPlace Makefile.in --replace 02770 0770
  '';

  preConfigure = ''
    # configure uses id to check environment; we don't want this check
    sed -re 's/^ID[=].*/ID="echo whatever"/' -i configure
  '';

  postConfigure = ''
      # The is_validfqdn is far too restrictive, and only allows
      # Internet-facing servers to run.  In order to run leafnode via
      # localhost only, we need to disable this check.
      sed -i validatefqdn.c -e 's/int is_validfqdn(const char \*f) {/int is_validfqdn(const char *f) { return 1;/;'
  '';

  buildInputs = [ pcre libxcrypt ];

  meta = {
    homepage = "http://leafnode.sourceforge.net/";
    description = "Implementation of a store & forward NNTP proxy";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
