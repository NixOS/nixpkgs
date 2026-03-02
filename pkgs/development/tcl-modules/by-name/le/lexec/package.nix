{
  lib,
  mkTclDerivation,
  fetchzip,
  autoreconfHook,
}:

mkTclDerivation {
  pname = "lexec";
  version = "0-unstable-2020-03-11";

  src = fetchzip {
    url = "https://chiselapp.com/user/pooryorick/repository/lexec/tarball/3880618cfe/unnamed-3880618cfe.tar.gz";
    hash = "sha256-MHsVcCPjdNn1ca6GFP4jWlDk7zioD0VSEh1CImud4fc=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Implementation of Tcl TIP 424 \"Improving [exec]\" as a separate package";
    homepage = "https://chiselapp.com/user/pooryorick/repository/lexec/index";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
}
