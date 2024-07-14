{ lib
, stdenv
, fetchFromGitHub
, gzip
, libvorbis
, libmad
, SDL2
, SDL2_mixer
, libpng
, alsa-lib
, gnutls
, zlib
, libjpeg
, vulkan-loader
, vulkan-headers
, speex
, libopus
, xorg
, libGL
}@attrs:
{
  fteqw = import ./generic.nix (rec {
    pname = "fteqw";

    buildFlags = [ "m-rel" ];

    nativeBuildInputs = [
      vulkan-headers
    ];

    buildInputs = [
      gzip
      libvorbis
      libmad
      SDL2
      SDL2_mixer
      libpng
      alsa-lib
      gnutls
      libjpeg
      vulkan-loader
      speex
      libopus
      xorg.libXrandr
      xorg.libXcursor
    ];

    postFixup = ''
      patchelf $out/bin/${pname} \
        --add-needed ${SDL2}/lib/libSDL2.so \
        --add-needed ${libGL}/lib/libGLX.so \
        --add-needed ${libGL}/lib/libGL.so \
        --add-needed ${lib.getLib gnutls}/lib/libgnutls.so \
        --add-needed ${vulkan-loader}/lib/libvulkan.so
    '';

    description = "Hybrid and versatile game engine";
  } // attrs);

  fteqw-dedicated = import ./generic.nix (rec {
    pname = "fteqw-dedicated";
    releaseFile = "fteqw-sv";

    buildFlags = [ "sv-rel" ];

    buildInputs = [
      gnutls
      zlib
    ];

    postFixup = ''
      patchelf $out/bin/${pname} \
        --add-needed ${gnutls}/lib/libgnutls.so \
    '';

    description = "Dedicated server for FTEQW";
  } // attrs);

  fteqcc = import ./generic.nix ({
    pname = "fteqcc";

    buildFlags = [ "qcc-rel" ];

    buildInputs = [
      zlib
    ];

    description = "User friendly QuakeC compiler";
  } // attrs);
}
