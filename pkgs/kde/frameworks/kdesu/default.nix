{
  mkKdeDerivation,
  lib,
}:
mkKdeDerivation {
  pname = "kdesu";

  # Look for NixOS SUID wrapper first
  patches = [ ./kdesu-search-for-wrapped-daemon-first.patch ];

  meta.badPlatforms = lib.platforms.darwin;
}
