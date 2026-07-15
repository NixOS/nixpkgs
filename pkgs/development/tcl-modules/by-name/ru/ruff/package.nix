{
  lib,
  mkTclDerivation,
  fetchzip,
  tcllib,
}:

mkTclDerivation rec {
  pname = "ruff";
  version = "2.4.2";

  src = fetchzip {
    url = "mirror://sourceforge/magicsplat/ruff/ruff-${version}.tgz";
    hash = "sha256-BeO0YtFDSg3e0ehdcpbojAw6WsInkiiHh01I0bYOkRY=";
  };

  dontBuild = true;

  propagatedBuildInputs = [
    tcllib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r . $out/lib/ruff

    runHook postInstall
  '';

  meta = {
    description = "Documentation generator for Tcl";
    longDescription = ''
      Ruff! (Runtime function formatter) is a documentation generation system
      for programs written in the Tcl programming language. Ruff! uses runtime
      introspection in conjunction with comment analysis to generate reference
      manuals for Tcl programs.
    '';
    homepage = "https://ruff.magicsplat.com/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
