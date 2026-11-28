# Removed or renamed home-assistant custom lovelace modules

_self: {
  # keep-sorted start case=no numeric=yes block=yes

  card-mod = throw "home-assistant-custom-lovelace-modules.card-mod has been removed in favor of its successor UIX. Remove it from `services.home-assistant.customLovelaceModules` and add `home-assistant-custom-components.uix` to `services.home-assistant.customComponents` instead. Existing `card_mod:` configuration keeps working."; # Added 2026-10-23
  # keep-sorted end
}
