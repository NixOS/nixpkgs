{ stdenv, makeWrapper, fetchurl, which, pkgconfig
, ocamlPackages
, libao, portaudio, alsaLib, libpulseaudio, libjack2
, libsamplerate, libmad, taglib, lame, libogg
, libvorbis, speex, libtheora, libopus, fdk_aac
, faad2, flac, ladspaH, ffmpeg, frei0r, dssi
}:

let
  pname = "liquidsoap";
  version = "1.3.4";

  packageFilters = map (p: "-e '/ocaml-${p}/d'" )
    [ "gstreamer" "shine" "aacplus" "schroedinger"
      "voaacenc" "soundtouch" "gavl" "lo"
    ];
in
stdenv.mkDerivation {
  name = "${pname}-full-${version}";

  src = fetchurl {
    url = "https://github.com/savonet/${pname}/releases/download/${version}/${pname}-${version}-full.tar.bz2";
    sha256 = "11l1h42sljfxcdhddc8klya4bk99j7a1pndwnzvscb04pvmfmlk0";
  };

  preConfigure = /* we prefer system-wide libs */ ''
    sed -i "s|gsed|sed|" Makefile
    make bootstrap
    # autoreconf -vi # use system libraries

    sed ${toString packageFilters} PACKAGES.default > PACKAGES
  '';

  postFixup = ''
    wrapProgram $out/bin/liquidsoap --set LIQ_LADSPA_PATH /run/current-system/sw/lib/ladspa
  '';

  configureFlags = [ "--localstatedir=/var" ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs =
    [ which ocamlPackages.ocaml ocamlPackages.findlib
      libao portaudio alsaLib libpulseaudio libjack2
      libsamplerate libmad taglib lame libogg
      libvorbis speex libtheora libopus fdk_aac
      faad2 flac ladspaH ffmpeg frei0r dssi
      ocamlPackages.xmlm ocamlPackages.ocaml_pcre
      ocamlPackages.camomile
    ];

  hardeningDisable = [ "format" "fortify" ];

  meta = with stdenv.lib; {
    description = "Swiss-army knife for multimedia streaming";
    homepage = https://www.liquidsoap.info/;
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = ocamlPackages.ocaml.meta.platforms or [];
  };
}
