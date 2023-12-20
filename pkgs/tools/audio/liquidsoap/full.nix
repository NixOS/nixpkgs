{ lib, stdenv, makeWrapper, fetchFromGitHub, which, pkg-config
, libjpeg
, ocamlPackages
, awscli2, bubblewrap, curl, ffmpeg, yt-dlp
, runtimePackages ? [ awscli2 bubblewrap curl ffmpeg yt-dlp ]
}:

let
  pname = "liquidsoap";
  version = "2.2.3";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "liquidsoap";
    rev = "refs/tags/v${version}";
    hash = "sha256-oCMSdmdU3oHrq3QFEDQLdb3CLFYcWylxTqKWtGOoQW8=";
  };

  postPatch = ''
    substituteInPlace src/lang/dune \
      --replace "(run git rev-parse --short HEAD)" "(run echo -n nixpkgs)"
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    dune build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dune install --prefix "$out"

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgram $out/bin/liquidsoap \
      --set LIQ_LADSPA_PATH /run/current-system/sw/lib/ladspa \
      --prefix PATH : ${lib.makeBinPath runtimePackages}

    runHook postFixup
  '';

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    which
    ocamlPackages.ocaml
    ocamlPackages.dune_3
    ocamlPackages.findlib
    ocamlPackages.menhir
  ];

  buildInputs = [
    libjpeg

    # Mandatory dependencies
    ocamlPackages.dtools
    ocamlPackages.duppy
    ocamlPackages.mm
    ocamlPackages.ocurl
    ocamlPackages.cry
    ocamlPackages.camomile
    ocamlPackages.uri
    ocamlPackages.fileutils
    ocamlPackages.menhir # liquidsoap-lang
    ocamlPackages.menhirLib
    ocamlPackages.metadata
    ocamlPackages.dune-build-info
    ocamlPackages.re
    ocamlPackages.sedlex # liquidsoap-lang
    ocamlPackages.ppx_string

    # Recommended dependencies
    ocamlPackages.ffmpeg

    # Optional dependencies
    ocamlPackages.alsa
    ocamlPackages.ao
    ocamlPackages.bjack
    ocamlPackages.camlimages
    ocamlPackages.dssi
    ocamlPackages.faad
    ocamlPackages.fdkaac
    ocamlPackages.flac
    ocamlPackages.frei0r
    ocamlPackages.gd4o
    ocamlPackages.graphics
    ocamlPackages.gstreamer
    ocamlPackages.imagelib
    ocamlPackages.inotify
    ocamlPackages.ladspa
    ocamlPackages.lame
    ocamlPackages.lastfm
    ocamlPackages.lilv
    ocamlPackages.lo
    ocamlPackages.mad
    ocamlPackages.magic
    ocamlPackages.ogg
    ocamlPackages.opus
    ocamlPackages.portaudio
    ocamlPackages.posix-time2
    ocamlPackages.pulseaudio
    ocamlPackages.samplerate
    ocamlPackages.shine
    ocamlPackages.soundtouch
    ocamlPackages.speex
    ocamlPackages.srt
    ocamlPackages.ssl
    ocamlPackages.taglib
    ocamlPackages.theora
    ocamlPackages.tsdl
    ocamlPackages.tsdl-image
    ocamlPackages.tsdl-ttf
    ocamlPackages.vorbis
    ocamlPackages.xmlplaylist
    ocamlPackages.yaml
  ];

  meta = with lib; {
    description = "Swiss-army knife for multimedia streaming";
    homepage = "https://www.liquidsoap.info/";
    maintainers = with maintainers; [ dandellion ehmry ];
    license = licenses.gpl2Plus;
    platforms = ocamlPackages.ocaml.meta.platforms or [];
  };
}
