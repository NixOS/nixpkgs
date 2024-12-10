{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  libadwaita,
}:

buildGoModule {
  pname = "catnip-gtk4";
  version = "unstable-2023-06-17";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = "catnip-gtk4";
    rev = "e635904af952fcee7e9f4b1a3e45ce8519428d9f";
    hash = "sha256-yJNw/pDgvIzcX4H6RoFJBiRwzWQXWF3obUPxYf4ALOY=";
  };

  vendorHash = "sha256-gcr3e5Fm2xCTOoTgl71Dv3rxI6gQbqRz0M1NO7fAZk0=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gobject-introspection
    gtk4
    libadwaita
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "GTK4 frontend for catnip";
    homepage = "https://github.com/diamondburned/catnip-gtk4";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "catnip-gtk4";
  };
}
