{ stdenv, fetchurl, pam, yacc, flex }:

stdenv.mkDerivation rec {
  name    = "libcgroup-${version}";
  version = "0.41";

  src = fetchurl {
    url = "mirror://sourceforge/libcg/${name}.tar.bz2";
    sha256 = "0lgvyq37gq84sk30sg18admxaj0j0p5dq3bl6g74a1ppgvf8pqz4";
  };

  buildInputs = [ pam yacc flex ];

  postPatch = ''
    substituteInPlace src/tools/Makefile.in \
      --replace 'chmod u+s' 'chmod +x'
  '';

  meta = {
    description = "Library and tools to manage Linux cgroups";
    homepage    = "http://libcg.sourceforge.net/";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
