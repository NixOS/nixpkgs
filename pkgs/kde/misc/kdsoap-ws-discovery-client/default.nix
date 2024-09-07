{
  lib,
  mkKdeDerivation,
  fetchurl,
  doxygen,
}:
mkKdeDerivation rec {
  pname = "kdsoap-ws-discovery-client";
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://kde/stable/kdsoap-ws-discovery-client/kdsoap-ws-discovery-client-${version}.tar.xz";
    hash = "sha256-LNJHwBPnX0EGWbrDcq/5PSLXHFpUwFnhN7lESvizQno=";
  };

  extraNativeBuildInputs = [doxygen];

  meta.license = [lib.licenses.gpl3Plus];
}
