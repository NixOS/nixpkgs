{ stdenv, fetchurl, pkgconfig, which, gettext, intltool
, glib, gtk2
, enableSoftening ? true
}:

stdenv.mkDerivation rec {
  name = "dvdisaster-0.72.6";

  src = fetchurl {
    url = "http://dvdisaster.net/downloads/${name}.tar.bz2";
    sha256 = "e9787dea39aeafa38b26604752561bc895083c17b588489d857ac05c58be196b";
  };

  patches = stdenv.lib.optional enableSoftening [
    ./encryption.patch
    ./dvdrom.patch
  ];

  postPatch = ''
    patchShebangs ./
    sed -i 's/dvdisaster48.png/dvdisaster/' contrib/dvdisaster.desktop
  '';

  # Explicit --docdir= is required for on-line help to work:
  configureFlags = [ "--docdir=$out/share/doc" ];

  buildInputs = [
    pkgconfig which gettext intltool
    glib gtk2
  ];

  postInstall = ''
    mkdir -pv $out/share/applications
    cp contrib/dvdisaster.desktop $out/share/applications/

    for size in 16 24 32 48 64; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps/
      cp contrib/dvdisaster"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/dvdisaster.png
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://dvdisaster.net/;
    description = "Data loss/scratch/aging protection for CD/DVD media";
    longDescription = ''
      Dvdisaster provides a margin of safety against data loss on CD and
      DVD media caused by scratches or aging media. It creates error correction
      data which is used to recover unreadable sectors if the disc becomes
      damaged at a later time.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
