{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtwebsockets,
  kdeclarative,
  kpackage,
}:
mkKdeDerivation rec {
  pname = "kunifiedpush";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/kunifiedpush/kunifiedpush-${version}.tar.xz";
    sha256 = "sha256-Ld66ITBtAwcRTsUKLDgVnsYjWfn8bN1Y2jCjafvVUM8=";
  };

  extraBuildInputs = [
    qtwebsockets
    kdeclarative
    kpackage
  ];

  meta.license = with lib.licenses; [
    bsd2
    bsd3
    cc0
    lgpl2Plus
  ];
  meta.mainProgram = "kunifiedpush-distributor";
}
