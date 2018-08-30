{ stdenv, fetchurl, e2fsprogs, openldap, pkgconfig }:

stdenv.mkDerivation rec {
  version = "4.04";
  name = "quota-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/linuxquota/quota-${version}.tar.gz";
    sha256 = "1pwfxza923j75z5lx0w89pj09745zi1swy77cm0zalbzgs4f2nvk";
  };

  outputs = [ "out" "dev" "doc" "man" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ e2fsprogs openldap ];

  meta = with stdenv.lib; {
    description = "Tools to manage kernel-level quotas in Linux";
    homepage = https://sourceforge.net/projects/linuxquota/;
    license = licenses.gpl2; # With some files being BSD as an exception
    platforms = platforms.linux;
    maintainers = [ maintainers.dezgeg ];
  };
}
