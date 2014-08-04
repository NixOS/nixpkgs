{ fetchurl, stdenv, libunwind, libraw1394, libjpeg, libiec61883, libdv
, libavc1394, pkgconfig }:

stdenv.mkDerivation rec {
  name = "dvgrab-3.5";

  src = fetchurl {
    url = "mirror://sourceforge/kino/${name}.tar.gz";
    sha256 = "1y8arv14nc9sf8njfcxf96pb4nyimpsly1fnhcbj406k54s1h42r";
  };

  buildInputs =
    [ libunwind libraw1394 libjpeg libiec61883 libdv libavc1394
      pkgconfig
    ];

  meta = {
    description = "dvgrab, receive and store audio & video over IEEE1394";

    longDescription =
      '' dvgrab receives audio and video data from a digital camcorder via an
         IEEE1394 (widely known as FireWire) or USB link and stores them into
         one of several file formats. It features autosplit of long video
         sequences, and supports saving the data as raw frames, AVI type 1,
         AVI type 2, Quicktime DV, a series of JPEG stills or MPEG2-TS.
      '';

    homepage = http://kinodv.org/;

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = [ ];
  };
}
