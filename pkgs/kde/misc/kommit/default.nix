{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  libgit2,
}:
mkKdeDerivation rec {
  pname = "kommit";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-rDDrXxqMQDXGSZ0nMl1JkSGsLeez04HKyw3XQn+0UCU=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ libgit2 ];

  meta.license = [ lib.licenses.gpl3Only ];
}
