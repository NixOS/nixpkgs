{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.20.0";

  src = fetchurl {
    url = "mirror://kde/stable/plasma-wayland-protocols/plasma-wayland-protocols-${version}.tar.xz";
    hash = "sha256-mBi7FGIhHOWYLmcKvw2WTrEf4dDAKhwmCE2zBpWnnWo=";
  };

  meta.license = with lib.licenses; [
    bsd3
    cc0
    lgpl21Plus
    mit
  ];
}
