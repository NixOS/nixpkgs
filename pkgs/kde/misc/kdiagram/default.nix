{
  lib,
  mkKdeDerivation,
  fetchurl,
  qttools,
  qtsvg,
}:
mkKdeDerivation rec {
  pname = "kdiagram";
  version = "3.0.1";

  src = fetchurl {
    url = "mirror://kde/stable/kdiagram/${version}/kdiagram-${version}.tar.xz";
    hash = "sha256-Rlmwws2dsYFD9avZyAYJHDqrarwalWu/goFas9MYnG0=";
  };

  extraNativeBuildInputs = [qttools qtsvg];

  meta.license = [lib.licenses.gpl2];
}
