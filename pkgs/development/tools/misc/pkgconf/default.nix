{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pkgconf";
  version = "1.7.0";

  src = fetchurl {
    url = "https://distfiles.dereferenced.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0sb1a2lgiqaninv5s3zq09ilrkpsamcl68dyhqyz7yi9vsgb0vhy";
  };

  meta = with stdenv.lib; {
    description = "Package compiler and linker metadata toolkit";
    homepage = "https://git.dereferenced.org/pkgconf/pkgconf";
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ zaninime ];
  };
}
