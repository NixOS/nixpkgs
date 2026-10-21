{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  ibus,
  libadwaita,
  libchewing,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus-chewing";
  version = "2.2.0";

  src = fetchFromCodeberg {
    owner = "chewing";
    repo = "ibus-chewing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0kXAvvbOsTUMmno6zzpRqpYb9xQlD4iwC1WNf5cMsSw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    ibus
    libadwaita
    libchewing
  ];

  enableParallelBuilding = true;

  meta = {
    isIbusEngine = true;
    description = "Chewing engine for IBus";
    homepage = "https://codeberg.org/chewing/ibus-chewing";
    changelog = "https://codeberg.org/chewing/ibus-chewing/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    platforms = lib.platforms.linux;
  };
})
