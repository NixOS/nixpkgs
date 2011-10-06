{stdenv, fetchurl, pam, yacc, flex}:

stdenv.mkDerivation rec {
  name = "libcgroup-0.37.1";

  src = fetchurl {
    url = "mirror://sourceforge/libcg/${name}.tar.bz2";
    sha256 = "03awrn49bb84a9vaha1kjdbpwdnrfwmd08mlajjilr6kwlnn620b";
  };

  buildInputs = [ pam ];

  buildNativeInputs = [ yacc flex ];
  meta = {
    description = "library that abstracts the control group file system in Linux";
    homepage = "http://libcg.sourceforge.net";
    license = "LGPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
