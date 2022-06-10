{ lib, stdenv, makeWrapper, fetchurl, which, pkg-config
, fetchFromGitLab
, ocamlPackages
, libao, portaudio, alsa-lib, libpulseaudio, libjack2
, libsamplerate, libmad, taglib, lame, libogg
, libvorbis, speex, libtheora, libopus, zlib
, faad2, flac, ladspaH, ffmpeg, frei0r, dssi
}:

let
  pname = "liquidsoap";
  version = "1.4.2";

  ocaml-ffmpeg = fetchurl {
    url = "https://github.com/savonet/ocaml-ffmpeg/releases/download/v0.4.2/ocaml-ffmpeg-0.4.2.tar.gz";
    sha256 = "1lx5s1avds9fsh77828ifn71r2g89rxakhs8pp995a675phm9viw";
  };

  packageFilters = map (p: "-e '/ocaml-${p}/d'" )
    [ "gstreamer" "shine" "aacplus" "schroedinger"
      "voaacenc" "soundtouch" "gavl" "lo"
    ];
in

# Liquidsoap 1.4.2 is not compatible with menhir ≥ 20220210
# Locally override menhir to an earlier version
let menhirLib = ocamlPackages.menhirLib.overrideAttrs (o: rec {
    version = "20211128";
    src = fetchFromGitLab {
      domain = "gitlab.inria.fr";
      owner = "fpottier";
      repo = "menhir";
      rev = version;
      sha256 = "sha256-L/zfjPZfn9L7qqqqJGk3Ge52rvujOVPiL8jxfH5R60g=";
    };
  });

  menhirSdk = ocamlPackages.menhirSdk.override { inherit menhirLib; };

  menhir = ocamlPackages.menhir.override {
    inherit menhirLib menhirSdk;
  };

in

stdenv.mkDerivation {
  name = "${pname}-full-${version}";

  src = fetchurl {
    url = "https://github.com/savonet/${pname}/releases/download/v${version}/${pname}-${version}-full.tar.gz";
    sha256 = "0wkwnzj1a0vizv7sr1blwk5gzm2qi0n02ndijnq1i50cwrgxs1a4";
  };

  # Use ocaml-srt and ocaml-fdkaac from nixpkgs
  # Use ocaml-ffmpeg at 0.4.2 for compatibility with ffmpeg 4.3
  prePatch = ''
    rm -rf ocaml-srt*/ ocaml-fdkaac*/ ocaml-ffmpeg*/
    tar xzf ${ocaml-ffmpeg}
  '';

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

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs =
    [ which ocamlPackages.ocaml ocamlPackages.findlib
      libao portaudio alsa-lib libpulseaudio libjack2
      libsamplerate libmad taglib lame libogg
      libvorbis speex libtheora libopus zlib
      faad2 flac ladspaH ffmpeg frei0r dssi
      ocamlPackages.xmlm ocamlPackages.ocaml_pcre
      ocamlPackages.camomile
      ocamlPackages.fdkaac
      ocamlPackages.srt ocamlPackages.sedlex menhir menhirLib
    ];

  hardeningDisable = [ "format" "fortify" ];

  meta = with lib; {
    description = "Swiss-army knife for multimedia streaming";
    homepage = "https://www.liquidsoap.info/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = ocamlPackages.ocaml.meta.platforms or [];
  };
}
