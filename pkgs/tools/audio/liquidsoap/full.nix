{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  which,
  pkg-config,
  libjpeg,
  ocamlPackages,
  awscli2,
  bubblewrap,
  curl,
  ffmpeg,
  yt-dlp,
  runtimePackages ? [
    awscli2
    bubblewrap
    curl
    ffmpeg
    yt-dlp
  ],
}:

let
  pname = "liquidsoap";
  version = "2.3.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "liquidsoap";
    # tag = "v${version}";
    # hash = "sha256-wNOENkIQw8LWfceI24aa8Ja3ZkePgTIGdIpGgqs/3Ss=";
    rev = "c0cd13a1f58164d2cab8cb322b90a24064beda17";
    hash = "sha256-5GTUEQX0rntVw0cNIyTtCMBmAbWVhHhjwhobWpA83kc=";
  };

  postPatch = ''
    substituteInPlace src/lang/dune \
      --replace-warn "(run git rev-parse --short HEAD)" "(run echo -n nixpkgs)"
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
    ocamlPackages.re
    # ocamlPackages.ocaml_pcre
    ocamlPackages.ocurl
    ocamlPackages.cry
    ocamlPackages.camomile
    ocamlPackages.uri
    ocamlPackages.fileutils
    ocamlPackages.menhirLib
    ocamlPackages.mem_usage
    ocamlPackages.metadata
    ocamlPackages.magic-mime
    ocamlPackages.dune-build-info
    ocamlPackages.ppx_string
    ## Liquidoap-lang
    ocamlPackages.saturn_lockfree
    ocamlPackages.ppx_hash
    ocamlPackages.sedlex
    # ocamlPackages.menhir
    ocamlPackages.xml-light

    # Optional dependencies
    ocamlPackages.alsa
    ocamlPackages.ao
    ocamlPackages.bjack
    ocamlPackages.camlimages
    ocamlPackages.ctypes-foreign
    ocamlPackages.dssi
    ocamlPackages.faad
    ocamlPackages.fdkaac
    ocamlPackages.ffmpeg
    ocamlPackages.flac
    ocamlPackages.frei0r
    ocamlPackages.gd
    ocamlPackages.graphics
    ocamlPackages.imagelib
    ocamlPackages.inotify
    # ocamlPackages.irc-client-unix # Missing
    # ocamlPackages.jemalloc # Missing
    ocamlPackages.ladspa
    ocamlPackages.lame
    ocamlPackages.lastfm
    ocamlPackages.lilv
    ocamlPackages.lo
    ocamlPackages.mad
    ocamlPackages.memtrace
    ocamlPackages.ogg
    ocamlPackages.opus
    # ocamlPackages.osc-unix # Missing
    ocamlPackages.portaudio
    ocamlPackages.posix-time2
    ocamlPackages.pulseaudio
    ## prometheus-liquidsoap # Missing
    ocamlPackages.samplerate
    ocamlPackages.shine
    ocamlPackages.soundtouch
    ocamlPackages.speex
    # ocamlPackages.sqlite3 # Missing
    ocamlPackages.srt
    ocamlPackages.ssl
    ## tls-liquidsoap
    ocamlPackages.tls
    ocamlPackages.ca-certs
    ocamlPackages.mirage-crypto-rng
    ocamlPackages.cstruct
    ##
    ocamlPackages.theora
    ## sdl-liquidsoap
    ocamlPackages.tsdl
    ocamlPackages.tsdl-image
    ocamlPackages.tsdl-ttf
    ##
    ocamlPackages.vorbis
    ocamlPackages.yaml
    ocamlPackages.xmlplaylist
  ];

  meta = {
    description = "Swiss-army knife for multimedia streaming";
    mainProgram = "liquidsoap";
    homepage = "https://www.liquidsoap.info/";
    changelog = "https://raw.githubusercontent.com/savonet/liquidsoap/main/CHANGES.md";
    maintainers = with lib.maintainers; [
      dandellion
      ehmry
    ];
    license = lib.licenses.gpl2Plus;
    platforms = ocamlPackages.ocaml.meta.platforms or [ ];
  };
}
