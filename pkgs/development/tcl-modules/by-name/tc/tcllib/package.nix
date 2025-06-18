{
  lib,
  fetchzip,
  mkTclDerivation,
  critcl,
  withCritcl ? true,
}:

mkTclDerivation rec {
  pname = "tcllib";
  version = "2.0";

  src = fetchzip {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    hash = "sha256-LoY6y7p9n1dXk4eSa/HuyA4bIXa0rN7F2OGESk2tROI=";
  };

  nativeBuildInputs = lib.optional withCritcl critcl;

  buildFlags = [ "all" ] ++ lib.optional withCritcl "critcl";

  meta = {
    homepage = "https://core.tcl-lang.org/tcllib/";
    description = "Tcl-only library of standard routines for Tcl";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
