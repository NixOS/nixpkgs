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
  '';

  # Explicit --docdir= is required for on-line help to work:
  configureFlags = [ "--docdir=$out/share/doc" ];

  buildInputs = [
    pkgconfig which gettext intltool
    glib gtk2
  ];

  meta = with stdenv.lib; {
    homepage = http://dvdisaster.net/;
    description = "data loss/scratch/aging protection for CD/DVD media";
    longDescription = ''
      dvdisaster provides a margin of safety against data loss on CD and
      DVD media caused by scratches or aging media. It creates error correction
      data which is used to recover unreadable sectors if the disc becomes
      damaged at a later time.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
