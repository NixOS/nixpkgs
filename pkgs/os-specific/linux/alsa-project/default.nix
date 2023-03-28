{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: {
  alsa-firmware = self.callPackage ./alsa-firmware { };
  alsa-lib = self.callPackage ./alsa-lib { };
  alsa-oss = self.callPackage ./alsa-oss { };
  alsa-plugins = self.callPackage ./alsa-plugins { };
  alsa-plugins-wrapper = self.callPackage ./alsa-plugins/wrapper.nix { };
  alsa-tools = self.callPackage ./alsa-tools { };
  alsa-topology-conf = self.callPackage ./alsa-topology-conf { };
  alsa-ucm-conf = self.callPackage ./alsa-ucm-conf { };
  alsa-utils = self.callPackage ./alsa-utils { fftw = pkgs.fftwFloat; };
})
