{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "kirigami-app-components";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://kde/stable/kirigami-app-components/kirigami-app-components-${version}.tar.xz";
    hash = "sha256-a/2eCjpLfRdQXww8DDlWKBZZc7b0zx5Keh8zQoc7RNA=";
  };

  meta.license = with lib.licenses; [
    bsd3
    cc0
    fsfap
    lgpl2Plus
    lgpl21Plus
  ];
}
