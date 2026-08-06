{ mkKdeDerivation, lib, fetchFromGitLab, libvirt, spice, libosinfo, pkg-config
, qtmultimedia, kirigami-addons
, spice-gtk, spice-protocol }:

mkKdeDerivation {
  pname = "karton";
  version = "unstable-2026-08-04";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "system";
    repo = "karton";
    rev = "bd0e933af452ee4fe11b697c7a0d337fb6a24254";
    hash = "sha256-238qKEzhePfX/GG9WWsy7Qd+Y5SGTXxTt4AGVJCqDjU=";
  };

  extraBuildInputs = [
    libvirt libosinfo
    qtmultimedia kirigami-addons
    spice spice-gtk spice-protocol
  ];

  extraNativeBuildInputs = [ pkg-config ];

  meta.mainProgram = "karton";
  meta.license = lib.licenses.gpl3Plus;
}
