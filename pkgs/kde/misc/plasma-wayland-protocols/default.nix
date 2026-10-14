{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.23.0";

  src = fetchurl {
    url = "mirror://kde/stable/plasma-wayland-protocols/plasma-wayland-protocols-${version}.tar.xz";
    hash = "sha256-FsWtkXveLteVlC2sunZlSBndxqFWaEIyXvNOC1U+8Tg=";
  };

  meta.license = with lib.licenses; [
    bsd3
    cc0
    lgpl21Plus
    mit
  ];
}
