{ stdenv, fetchurl
, withGUI? false, gtk? null, pkgconfig? null, sqlite? null  # compile GUI
 }:
stdenv.mkDerivation rec {

  name = "lshw-${version}";
  version = "02.17b";

  src = fetchurl {
    url = http://ezix.org/software/files/lshw-B.02.17.tar.gz;
    sha256 = "1728b96gyjmrp31knzips9azn6wkfdp5k5dnbil7h7hgz99w177b";
  };

  buildInputs = [] ++ stdenv.lib.optional withGUI [ gtk pkgconfig sqlite ];

  postBuild = if withGUI then "make gui" else "";

  installPhase = ''
    make DESTDIR="$out" install
    ${if withGUI then "make DESTDIR=$out install-gui" else ""}
    mv $out/usr/* $out
    rmdir $out/usr
  '';

  meta = with stdenv.lib; {
    homepage = http://ezix.org/project/wiki/HardwareLiSter;
    description = "Provide detailed information on the hardware configuration of the machine";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
