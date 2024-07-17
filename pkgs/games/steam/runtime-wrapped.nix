{
  stdenv,
  steamArch,
  lib,
  perl,
  pkgs,
  steam-runtime,
  runtimeOnly ? false,
}:

let
  overridePkgs = lib.optionals (!runtimeOnly) (
    with pkgs;
    [
      libgpg-error
      libpulseaudio
      alsa-lib
      openalSoft
      libva1
      libvdpau
      vulkan-loader
      gcc.cc.lib
      nss
      nspr
      xorg.libxcb
    ]
  );

  allPkgs = overridePkgs ++ [ steam-runtime ];

  gnuArch =
    if steamArch == "amd64" then
      "x86_64-linux-gnu"
    else if steamArch == "i386" then
      "i386-linux-gnu"
    else
      throw "Unsupported architecture";

  libs = [
    "lib/${gnuArch}"
    "lib"
    "usr/lib/${gnuArch}"
    "usr/lib"
  ];
  bins = [
    "bin"
    "usr/bin"
  ];

in
stdenv.mkDerivation {
  name = "steam-runtime-wrapped";

  nativeBuildInputs = [ perl ];

  builder = ./build-wrapped.sh;

  passthru = {
    inherit
      gnuArch
      libs
      bins
      overridePkgs
      ;
    arch = steamArch;
  };

  installPhase = ''
    buildDir "${toString libs}" "${toString (map lib.getLib allPkgs)}"
    buildDir "${toString bins}" "${toString (map lib.getBin allPkgs)}"
  '';
}
