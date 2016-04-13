{ stdenv, fetchurl, which, pkgconfig
, ocaml, ocamlPackages
, libao, portaudio, alsaLib, libpulseaudio, libjack2
, libsamplerate, libmad, taglib, lame, libogg
, libvorbis, speex, libtheora, libopus, fdk_aac
, faad2, flac, ladspaH, ffmpeg, frei0r, dssi
, }:

let
  version = "1.1.1";

  packageFilters = map (p: "-e '/ocaml-${p}/d'" )
    [ "gstreamer" "shine" "aacplus" "schroedinger"
      "voaacenc" "soundtouch" "gavl" "lo"
    ];
in
stdenv.mkDerivation {
  name = "liquidsoap-full-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/savonet/liquidsoap/${version}/liquidsoap-${version}-full.tar.gz";
    sha256 = "1w1grgja5yibph90vsxj7ffkpz1sgzmr54jj52s8889dpy609wqa";
  };

  preConfigure = "sed ${toString packageFilters} PACKAGES.default > PACKAGES";
  configureFlags = [ "--localstatedir=/var" ];

  buildInputs =
    [ which ocaml ocamlPackages.findlib pkgconfig
      libao portaudio alsaLib libpulseaudio libjack2
      libsamplerate libmad taglib lame libogg
      libvorbis speex libtheora libopus fdk_aac
      faad2 flac ladspaH ffmpeg frei0r dssi
      ocamlPackages.xmlm ocamlPackages.ocaml_pcre
      ocamlPackages.camomile
    ];

  meta = with stdenv.lib; {
    description = "Swiss-army knife for multimedia streaming";
    homepage = http://liquidsoap.fm/;
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = ocaml.meta.platforms or [];
  };
}
