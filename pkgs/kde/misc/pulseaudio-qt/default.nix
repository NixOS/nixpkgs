{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  pulseaudio,
}:
mkKdeDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.9.0";

  src = fetchurl {
    url = "mirror://kde/stable/pulseaudio-qt/pulseaudio-qt-${version}.tar.xz";
    hash = "sha256-wqrOOsGpyMm5xXug/8maPTEHN8wATbBJGALgNTbifGk=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ pulseaudio ];

  meta.license = with lib.licenses; [
    lgpl21Only
    lgpl3Only
  ];
}
