{ stdenv
, fetchurl, qttools, pkgconfig
, minizip, zlib
, qtbase, qtsvg, qtmultimedia, qtwebkit, qttranslations, qtxmlpatterns
, rsync, SDL2, xwininfo
, utillinux
, xorg
}:

stdenv.mkDerivation rec {
  pname = "qmc2";
  version = "0.195";

  src = fetchurl {
      url = "mirror://sourceforge/project/qmc2/qmc2/${version}/${pname}-${version}.tar.gz";
      sha256 = "1dzmjlfk8pdspns6zg1jmd5fqzg8igd4q38cz4a1vf39lx74svns";
  };
  
  preBuild = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [ qttools pkgconfig ];
  buildInputs = [ minizip qtbase qtsvg qtmultimedia qtwebkit
                  qttranslations qtxmlpatterns rsync SDL2
                  xwininfo zlib utillinux xorg.libxcb ];

  makeFlags = [ "DESTDIR=$(out)"
                "PREFIX=/"
                "DATADIR=/share/"
                "SYSCONFDIR=/etc" ];

  meta = with stdenv.lib; {
    description = "A Qt frontend for MAME/MESS";
    homepage = https://qmc2.batcom-it.net;
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
