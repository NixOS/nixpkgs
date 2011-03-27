{ stdenv, fetchurl, python }:
stdenv.mkDerivation rec {

  name = "sepolgen-${version}";
  version = "1.0.23";

  src = fetchurl {
    url = http://userspace.selinuxproject.org/releases/20101221/devel/sepolgen-1.0.23.tar.gz;
    sha256 = "04d11l091iclp8lnay9as7y473ydrjz7171h95ddsbn0ihj5if2p";
  };

  buildInputs = [ python ];
  preBuild = '' makeFlags="$makeFlags DESTDIR=$out PACKAGEDIR=$out/lib/${python.libPrefix}/site-packages/sepolgen" '';

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org/;
    description = "Python module for SELinux policy generation";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}