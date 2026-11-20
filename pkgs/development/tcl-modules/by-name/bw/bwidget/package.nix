{
  lib,
  fetchurl,
  mkTclDerivation,
  tk,
}:

mkTclDerivation (finalAttrs: {
  pname = "bwidget";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${finalAttrs.version}.tar.gz";
    hash = "sha256-61sCvsua+Iv3SldHhd4eMpzzCjZ5EVMJOnkRT6xRw60=";
  };

  dontBuild = true;
  propagatedBuildInputs = [ tk ];

  installPhase = ''
    mkdir -p "$out/lib/bwidget${finalAttrs.version}"
    cp -R *.tcl lang images "$out/lib/bwidget${finalAttrs.version}"
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/tcllib";
    description = "High-level widget set for Tcl/Tk";
    maintainers = with lib.maintainers; [ agbrooks ];
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
  };
})
