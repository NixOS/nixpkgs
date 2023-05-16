{ lib, stdenv, fetchurl, pcre, libxcrypt }:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "leafnode";
  version = "2.0.0.alpha20140727b";

  src = fetchurl {
    url = "http://krusty.dt.e-technik.tu-dortmund.de/~ma/leafnode/beta/leafnode-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-NOuiy7uHG3JMjV3UAtHDWK6yG6QmvrVljhVe0NdGEHU=";
=======
stdenv.mkDerivation {
  pname = "leafnode";
  version = "2.0.0.alpha20121101a.12";

  src = fetchurl {
    url = "http://home.pages.de/~mandree/leafnode/beta/leafnode-2.0.0.alpha20121101a.tar.bz2";
    sha256 = "096w4gxj08m3vwmyv4sxpmbl8dn6mzqfmrhc32jgyca6qzlrdin8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  configureFlags = [ "--enable-runas-user=nobody" ];

  prePatch = ''
    substituteInPlace Makefile.in --replace 02770 0770
  '';

<<<<<<< HEAD
  # configure uses id to check environment; we don't want this check
  preConfigure = ''
    sed -re 's/^ID[=].*/ID="echo whatever"/' -i configure
  '';

  # The is_validfqdn is far too restrictive, and only allows
  # Internet-facing servers to run.  In order to run leafnode via
  # localhost only, we need to disable this check.
  postConfigure = ''
    sed -i validatefqdn.c -e 's/int is_validfqdn(const char \*f) {/int is_validfqdn(const char *f) { return 1;/;'
=======
  preConfigure = ''
    # configure uses id to check environment; we don't want this check
    sed -re 's/^ID[=].*/ID="echo whatever"/' -i configure
  '';

  postConfigure = ''
      # The is_validfqdn is far too restrictive, and only allows
      # Internet-facing servers to run.  In order to run leafnode via
      # localhost only, we need to disable this check.
      sed -i validatefqdn.c -e 's/int is_validfqdn(const char \*f) {/int is_validfqdn(const char *f) { return 1;/;'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  buildInputs = [ pcre libxcrypt ];

  meta = {
<<<<<<< HEAD
    homepage = "https://leafnode.sourceforge.io/index.shtml";
    description = "Implementation of a store & forward NNTP proxy, under development";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ne9z ];
  };
})
=======
    homepage = "http://leafnode.sourceforge.net/";
    description = "Implementation of a store & forward NNTP proxy";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
