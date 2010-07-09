{stdenv, fetchurl, pam, yacc, flex}:

stdenv.mkDerivation rec {
  name = "libcgroup-0.36.2";
  src = fetchurl {
    url = "mirror://sourceforge/libcg/${name}.tar.bz2";
    sha256 = "1qvkd976485vyshaq1cwjzg6w54c3djsaic024yx3sfp14f1gnvz";
  };
  buildInputs = [ pam yacc flex ];
  meta = {
    description = "library that abstracts the control group file system in Linux";
    homepage = "http://libcg.sourceforge.net";
    license = "LGPL";
  };
}
