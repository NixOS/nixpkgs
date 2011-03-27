{ stdenv, fetchurl, libsepol, libselinux, bison, flex }:
stdenv.mkDerivation rec {

  name = "checkpolicy-${version}";
  version = "2.0.23";

  src = fetchurl {
    url = "http://userspace.selinuxproject.org/releases/20101221/devel/checkpolicy-2.0.23.tar.gz";
    sha256 = "1n34ggacds7xap039r6hqkxmkd4g2wgfkxjdnv3lirq3cqqi8cnd";
  };

  buildInputs = [ libsepol libselinux bison flex ];

  preBuild = '' makeFlags="$makeFlags LEX=flex LIBDIR=${libsepol}/lib PREFIX=$out" '';

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org/;
    description = "SELinux policy compiler";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}