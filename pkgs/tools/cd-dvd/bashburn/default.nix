{ stdenv, fetchurl, utillinux
, cdparanoia, cdrdao, dvdplusrwtools, flac, lame, mpg123, normalize
, vorbis-tools, xorriso }:

stdenv.mkDerivation rec {
  name = "bashburn-${version}";
  version = "3.1.0";

  src = fetchurl {
    sha256 = "0g5va5rjdrvacanmqr6pbxk2rl565ahkfbsvxsp1jvhvxvhmv3dp";
    url = "http://bashburn.dose.se/index.php?s=file_download&id=25";
    name = "${name}.tar.gz";
  };

  nativeBuildInputs = [ utillinux ];

  postPatch = ''
    for path in \
      BB_CDBURNCMD=${xorriso}/bin/"xorriso -as cdrecord" \
      BB_DVDBURNCMD=${dvdplusrwtools}/bin/growisofs \
      BB_ISOCMD=${xorriso}/bin/"xorriso -as mkisofs" \
      BB_DVDBLANK=${dvdplusrwtools}/bin/dvd+rw-format \
      BB_CDIMAGECMD=${cdrdao}/bin/cdrdao \
      BB_CDAUDIORIP=${cdparanoia}/bin/cdparanoia \
      BB_READCD=${xorriso}/bin/"xorriso -as mkisofs" \
      BB_MP3ENC=${lame}/bin/lame \
      BB_MP3DEC=${mpg123}/bin/mpg123 \
      BB_OGGENC=${vorbis-tools}/bin/oggenc \
      BB_OGGDEC=${vorbis-tools}/bin/oggdec \
      BB_FLACCMD=${flac.bin}/bin/flac \
      BB_EJECT=${utillinux}/bin/eject \
      BB_NORMCMD=${normalize}/bin/normalize \
    ; do
      echo $path
      sed -i BashBurn.sh \
        -e "s,\(''${path%%=*}:\).*,\1 ''${path#*=},"
      sed -i menus/advanced.sh \
        -e "s,\(''${path%%=*}|\).*\('.*\),\1''${path#*=}\2,"
    done
  '';

  installPhase = ''
    sh Install.sh --prefix $out
  '';

  meta = with stdenv.lib; {
    description = "Bash script CD Burner Writer";
    longDescription = ''
      It might not be the best looking application out there, but it works.
      It’s simple, fast and small, and can handle most things you throw at it.
      Currently (and with the right dependencies installed), BashBurn can:
      - burn data CDs/DVDs (Including CDRWs)
      - burn music CDs
      - burn CD/DVD-images
      - rip data/music CDs
      - manipulate ISO-files
      - and probably more...
    '';
    homepage = http://bashburn.dose.se/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
