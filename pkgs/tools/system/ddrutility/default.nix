{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ddrutility";
  version = "2.8";

  src = fetchurl {
    url = "mirror://sourceforge/ddrutility/${pname}-${version}.tar.gz";
    sha256 = "023g7f2sfv5cqk3iyss4awrw3b913sy5423mn5zvlyrri5hi2cac";
  };

  postPatch = ''
    substituteInPlace makefile --replace /usr/local ""
  '';

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A set of utilities for hard drive data rescue";
    homepage = "https://sourceforge.net/projects/ddrutility/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
