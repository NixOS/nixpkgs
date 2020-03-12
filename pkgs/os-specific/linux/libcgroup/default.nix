{ stdenv, fetchurl, fetchpatch, pam, yacc, flex }:

stdenv.mkDerivation rec {
  pname = "libcgroup";
  version = "0.41";

  src = fetchurl {
    url = "mirror://sourceforge/libcg/${pname}-${version}.tar.bz2";
    sha256 = "0lgvyq37gq84sk30sg18admxaj0j0p5dq3bl6g74a1ppgvf8pqz4";
  };

  buildInputs = [ pam yacc flex ];

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/libcgroup/files/libcgroup-0.41-remove-umask.patch?id=33e9f4c81de754bbf76b893ea1133ed023f2a0e5";
      sha256 = "1x0x29ld0cgmfwq4qy13s6d5c8sym1frfh1j2q47d8gfw6qaxka5";
    })
  ];

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
