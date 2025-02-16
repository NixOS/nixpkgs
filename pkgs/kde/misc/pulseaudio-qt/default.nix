{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  pulseaudio,
}:
mkKdeDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://kde/stable/pulseaudio-qt/pulseaudio-qt-${version}.tar.xz";
    hash = "sha256-ahjbdt0rzD332ak3nAJSlYFyZLqh8u2Mqqx9pE4E6TE=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ pulseaudio ];

  meta.license = with lib.licenses; [
    lgpl21Only
    lgpl3Only
  ];
}
