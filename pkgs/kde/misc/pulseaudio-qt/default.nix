{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  pulseaudio,
}:
mkKdeDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.8.1";

  src = fetchurl {
    url = "mirror://kde/stable/pulseaudio-qt/pulseaudio-qt-${version}.tar.xz";
    hash = "sha256-eWGcVblICKp9MH+yNK05oQltCI8h+Aa+DniL55p2s8k=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ pulseaudio ];

  meta.license = with lib.licenses; [
    lgpl21Only
    lgpl3Only
  ];
}
