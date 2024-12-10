{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  pulseaudio,
}:
mkKdeDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://kde/stable/pulseaudio-qt/pulseaudio-qt-${version}.tar.xz";
    hash = "sha256-2MpiTs8hMIVrhZz5NBF39v74xR8g93KNgH0JxxUO0GU=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ pulseaudio ];

  meta.license = with lib.licenses; [
    lgpl21Only
    lgpl3Only
  ];
}
