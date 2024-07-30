{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  pulseaudio,
}:
mkKdeDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://kde/stable/pulseaudio-qt/pulseaudio-qt-${version}.tar.xz";
    hash = "sha256-zY9RyHAAc9D9kNV4QIOs63PnK6mnBOYF4KZ5CUJqhSA=";
  };

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [pulseaudio];

  meta.license = with lib.licenses; [lgpl21Only lgpl3Only];
}
