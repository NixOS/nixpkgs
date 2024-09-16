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
  version = "0.200.0";

  src = fetchurl {
    url = "mirror://kde/stable/polkit-qt-1/polkit-qt-1-${version}.tar.xz";
    sha256 = "sha256-XTthHAYtK3apN1C7EMkHv9IdH/CNChXcLPY+J44Wd/s=";
  };

  patches = [./full-paths.patch];

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [glib polkit];

  meta.license = with lib.licenses; [bsd3 gpl2Plus lgpl2Plus];
}
