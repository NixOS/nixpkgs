{ stdenv, fetchurl, pam, yacc, flex }:

stdenv.mkDerivation rec {
  name = "libcgroup-0.38";

  src = fetchurl {
    url = "mirror://sourceforge/libcg/${name}.tar.bz2";
    sha256 = "0zw6144jlvzx0hasl4b07vjfa4lm12jaax6zzkljzxlmifjd2djx";
  };

  buildInputs = [ pam ];

  nativeBuildInputs = [ yacc flex ];

  meta = {
    description = "Library and tools to manage Linux's cgroup resource management system";
    homepage = http://libcg.sourceforge.net/;
    license = "LGPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
