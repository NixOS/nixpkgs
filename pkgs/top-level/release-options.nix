{ pkgs ? import ../..
, lib ? import ../../lib }:

lib.mapAttrs (n: v: pkgs v) {
  headlessLinux = {
    config = {
      withGtk = false;
      withQt = false;
      withPulseAudio = false;
      withJack = false;
      withAlsa = false;
      withWayland = false;
      withX11 = false;
    };
    localSystem = { system = "x86_64-linux"; };
  };
  freeDarwin = {
    config = {
      withApple = false;
      allowUnfree = false;
    };
    localSystem = { system = "x86_64-darwin"; };
  };
  slnosLinux = {
    config = {
      withSystemd = false;
      withPulseAudio = false;
    };
    localSystem = { system = "x86_64-linux"; };
  };
  staticLinux = {
    config = {
      enableStatic = true;
      enableDynamic = false;
    };
    localSystem = { system = "x86_64-linux"; };
  };
  staticDarwin = {
    config = {
      enableStatic = true;
      enableDynamic = false;
    };
    localSystem = { system = "x86_64-darwin"; };
  };
}
