{ stdenv, fetchurl
, withGUI? false, gtk? null, pkgconfig? null, sqlite? null  # compile GUI
 }:
stdenv.mkDerivation rec {

  name = "lshw-${version}";
  version = "02.15b";

  src = fetchurl {
    url = http://ezix.org/software/files/lshw-B.02.15.tar.gz;
    sha256 = "19im6yj1pmsbrwkvdmgshllhiw7jh6nzhr6dc777q1n99g3cw0gv";
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
