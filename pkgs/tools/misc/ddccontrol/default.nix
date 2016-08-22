{ stdenv
, fetchurl
, intltool
, libtool
, autoconf
, automake110x
, perl
, perlPackages
, libxml2
, pciutils
, pkgconfig
, gtk
, ddccontrol-db
}:

let version = "0.4.2"; in
stdenv.mkDerivation {
  name = "ddccontrol-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ddccontrol/ddccontrol-${version}.tar.bz2";
    sha1 = "fd5c53286315a61a18697a950e63ed0c8d5acff1";
  };

  buildInputs =
    [
      intltool
      libtool
      autoconf
      automake110x
      perl
      perlPackages.libxml_perl
      libxml2
      pciutils
      pkgconfig
      gtk
      ddccontrol-db
    ];

  hardeningDisable = [ "format" ];

  prePatch = ''
      newPath=$(echo "${ddccontrol-db}/share/ddccontrol-db" | sed "s/\\//\\\\\\//g")
      mv configure.ac configure.ac.old
      oldPath="\$"
      oldPath+="{datadir}\/ddccontrol-db"
      sed "s/$oldPath/$newPath/" <configure.ac.old >configure.ac
      rm configure.ac.old
  '';
  preConfigure = ''
      autoreconf --install
  '';

  meta = with stdenv.lib; {
    description = "A program used to control monitor parameters by software";
    homepage = "http://ddccontrol.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ stdenv.lib.maintainers.pakhfn ];
  };
}

