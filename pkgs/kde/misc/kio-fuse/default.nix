{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  fuse3,
}:
mkKdeDerivation rec {
  pname = "kio-fuse";
  version = "5.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/kio-fuse/kio-fuse-${version}.tar.xz";
    hash = "sha256-fRBFgSJ9Whm0JLM/QWjRgVVrEBXW3yIY4BqI1kRJ6Us=";
  };

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [fuse3];

  meta.license = with lib.licenses; [gpl3Plus];
}
