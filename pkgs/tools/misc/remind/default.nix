{ lib
, stdenv
, fetchurl
, tk
, tcllib
, makeWrapper
, tkremind ? true
}:

let
  inherit (lib) optional optionalString;
  tclLibraries = lib.optionals tkremind [ tcllib tk ];
  tclLibPaths = lib.concatStringsSep " "
    (map (p: "${p}/lib/${p.libPrefix}") tclLibraries);
  tkremindPatch = optionalString tkremind ''
    substituteInPlace scripts/tkremind --replace "exec wish" "exec ${tk}/bin/wish"
  '';
in
stdenv.mkDerivation rec {
  pname = "remind";
  version = "03.03.06";

  src = fetchurl {
    url = "https://dianne.skoll.ca/projects/remind/download/remind-${version}.tar.gz";
    sha256 = "sha256-lpoMAXDJxwODY0/aoo25GRBYWFhE4uf11pR5/ITZX1s=";
  };

  nativeBuildInputs = optional tkremind makeWrapper;
  propagatedBuildInputs = tclLibraries;

  postPatch = ''
    substituteInPlace ./configure \
      --replace "sleep 1" "true"
    substituteInPlace ./src/init.c \
      --replace "rkrphgvba(0);" "" \
      --replace "rkrphgvba(1);" ""
    ${tkremindPatch}
  '';

  postInstall = optionalString tkremind ''
    wrapProgram $out/bin/tkremind --set TCLLIBPATH "${tclLibPaths}"
  '';

  meta = with lib; {
    homepage = "https://dianne.skoll.ca/projects/remind/";
    description = "Sophisticated calendar and alarm program for the console";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ raskin kovirobi ];
    platforms = platforms.unix;
  };
}
