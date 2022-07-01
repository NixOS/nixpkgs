{ lib, stdenv, makeWrapper, fetchurl, which, pkg-config
, libjpeg
, ocamlPackages
, awscli2, curl, ffmpeg, youtube-dl
, runtimePackages ? [ awscli2 curl ffmpeg youtube-dl ]
}:

let
  pname = "liquidsoap";
  version = "2.0.6";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/savonet/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-1wD9BApbDA/ovzZoniay+jciP/V2C8EoGQehd5N8PPQ=";
  };

  postFixup = ''
    wrapProgram $out/bin/liquidsoap \
      --set LIQ_LADSPA_PATH /run/current-system/sw/lib/ladspa \
      --prefix PATH : ${lib.makeBinPath runtimePackages}
  '';

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [
      libjpeg
      which
      ocamlPackages.ocaml ocamlPackages.findlib

      # Mandatory dependencies
      ocamlPackages.dtools
      ocamlPackages.duppy
      ocamlPackages.mm
      ocamlPackages.ocaml_pcre
      ocamlPackages.menhir ocamlPackages.menhirLib
      ocamlPackages.sedlex

      # Recommended dependencies
      ocamlPackages.camomile
      ocamlPackages.samplerate

      # Optional dependencies
      ocamlPackages.camlimages
      ocamlPackages.gd4o
      ocamlPackages.alsa
      ocamlPackages.ao
      ocamlPackages.bjack
      ocamlPackages.cry
      ocamlPackages.dssi
      ocamlPackages.faad
      ocamlPackages.fdkaac
      ocamlPackages.srt
      ocamlPackages.ffmpeg
      ocamlPackages.flac
      ocamlPackages.frei0r
      ocamlPackages.gstreamer
      ocamlPackages.inotify
      ocamlPackages.ladspa
      ocamlPackages.lame
      ocamlPackages.lastfm
      ocamlPackages.lo
      ocamlPackages.mad
      ocamlPackages.magic
      ocamlPackages.ogg
      ocamlPackages.opus
      ocamlPackages.portaudio
      ocamlPackages.pulseaudio
      ocamlPackages.shine
      ocamlPackages.soundtouch
      ocamlPackages.speex
      ocamlPackages.srt
      ocamlPackages.ssl
      ocamlPackages.taglib
      ocamlPackages.theora
      ocamlPackages.vorbis
      ocamlPackages.xmlplaylist
      ocamlPackages.posix-time2
      ocamlPackages.tsdl
      ocamlPackages.tsdl-image
      ocamlPackages.tsdl-ttf

      # Undocumented dependencies
      ocamlPackages.ocurl
      ocamlPackages.lilv
      ocamlPackages.graphics
      ocamlPackages.yojson
      ocamlPackages.cohttp-lwt-unix
    ];

  meta = with lib; {
    description = "Swiss-army knife for multimedia streaming";
    homepage = "https://www.liquidsoap.info/";
    maintainers = with maintainers; [ dandellion ehmry ];
    license = licenses.gpl2Plus;
    platforms = ocamlPackages.ocaml.meta.platforms or [];
  };
}
