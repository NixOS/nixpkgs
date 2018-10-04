{ stdenv, fetchurl, which, pkgconfig
, ocamlPackages
, libao, portaudio, alsaLib, libpulseaudio, libjack2
, libsamplerate, libmad, taglib, lame, libogg
, libvorbis, speex, libtheora, libopus, fdk_aac
, faad2, flac, ladspaH, ffmpeg, frei0r, dssi
, autoconf, automake, libtool
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

  configureFlags = [ "--localstatedir=/var" ];

  # liquidsoap only looks for lame and ffmpeg at runtime, so we need to link them in manually
  NIX_LDFLAGS = [
  #   # LAME
  #   # "-lmp3lame"
  #   # ffmpeg
  #   "-lavcodec"
  #   "-lavdevice"
  #   "-lavfilter"
  #   "-lavformat"
    "-lavresample"
  #   "-lavutil"
  #   "-lpostproc"
  #   "-lswresample"
    "-lswscale"
  ];

  buildInputs =
    [ which ocamlPackages.ocaml ocamlPackages.findlib pkgconfig
      libao portaudio alsaLib libpulseaudio libjack2
      libsamplerate libmad taglib lame libogg
      libvorbis speex libtheora libopus fdk_aac
      faad2 flac ladspaH ffmpeg frei0r dssi
      ocamlPackages.xmlm ocamlPackages.ocaml_pcre
      ocamlPackages.camomile
      # autoconf automake libtool
    ];

  hardeningDisable = [ "format" "fortify" ];

  meta = with stdenv.lib; {
    description = "Swiss-army knife for multimedia streaming";
    homepage = http://liquidsoap.fm/;
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = ocamlPackages.ocaml.meta.platforms or [];
  };
}
