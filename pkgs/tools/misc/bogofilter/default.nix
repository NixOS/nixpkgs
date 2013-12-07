{fetchurl, stdenv, flex, bdb}:

stdenv.mkDerivation rec {
  name = "bogofilter-1.1.7";
  src = fetchurl {
    url = "mirror://sourceforge/bogofilter/${name}.tar.bz2";
    sha256 = "0ahi3pxv9v6yjjpfyr0x7fch4c4jdikshrcx86q0j8s2rhv94snm";
  };

  # FIXME: We would need `pax' as a "propagated build input" (for use
  # by the `bf_tar' script) but we don't have it currently.

  buildInputs = [ flex bdb ];

  meta = {
    homepage = http://bogofilter.sourceforge.net/;
    longDescription = ''
      Bogofilter is a mail filter that classifies mail as spam or ham
      (non-spam) by a statistical analysis of the message's header and
      content (body).  The program is able to learn from the user's
      classifications and corrections.  It is based on a Bayesian
      filter.
    '';
    license = "GPLv2";
  };
}
