{ lib
, stdenv
, fetchurl
, tk
, tcllib
, tcl
, tkremind ? true
}:

let
  inherit (lib) optional optionals optionalString;
  tclLibraries = optionals tkremind [ tcllib tk ];
  tkremindPatch = optionalString tkremind ''
    substituteInPlace scripts/tkremind --replace "exec wish" "exec ${tk}/bin/wish"
  '';
in
tcl.mkTclDerivation rec {
  pname = "remind";
  version = "04.00.00";

  src = fetchurl {
    url = "https://dianne.skoll.ca/projects/remind/download/remind-${version}.tar.gz";
    sha256 = "sha256-I7bmsO3EAUnmo2KoIy5myxXuZB8tzs5kCEXpG550x8Y=";
  };

  propagatedBuildInputs = tclLibraries;

  postPatch = ''
    substituteInPlace ./configure \
      --replace "sleep 1" "true"
    substituteInPlace ./src/init.c \
      --replace "rkrphgvba(0);" "" \
      --replace "rkrphgvba(1);" ""
    ${tkremindPatch}
  '';

  meta = with lib; {
    homepage = "https://dianne.skoll.ca/projects/remind/";
    description = "Sophisticated calendar and alarm program for the console";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ raskin kovirobi ];
    platforms = platforms.unix;
  };
}
