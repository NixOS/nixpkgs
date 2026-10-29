{
  mkKdeDerivation,
  lib,
  fetchurl,
  pkg-config,
  polkit,
  glib,
}:
mkKdeDerivation rec {
  pname = "polkit-qt-1";
  version = "0.201.1";

  src = fetchurl {
    url = "mirror://kde/stable/polkit-qt-1/polkit-qt-1-${version}.tar.xz";
    sha256 = "sha256-ldjiyuUwxUbZQ3RZ3rihvqONVy8Pl3LMKGDcFDY38lY=";
  };

  patches = [ ./full-paths.patch ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    glib
    polkit
  ];

  meta.license = with lib.licenses; [
    bsd3
    gpl2Plus
    lgpl2Plus
  ];
}
