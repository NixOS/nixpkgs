{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.19.0";

  src = fetchurl {
    url = "mirror://kde/stable/plasma-wayland-protocols/plasma-wayland-protocols-${version}.tar.xz";
    hash = "sha256-RWef56Y8QU8sgXk6YlKPrmzO5YS2llcZ1/n8bdSLqEY=";
  };

  meta.license = with lib.licenses; [
    bsd3
    cc0
    lgpl21Plus
    mit
  ];
}
