{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apparix";
  version = "11-062";

  src = fetchurl {
    url = "https://micans.org/apparix/src/apparix-${version}.tar.gz";
    sha256 = "211bb5f67b32ba7c3e044a13e4e79eb998ca017538e9f4b06bc92d5953615235";
  };

  doCheck = true;

  meta = with lib; {
    homepage = "http://micans.org/apparix";
    description = "Add directory bookmarks, distant listing, and distant editing to the command line";
    maintainers = [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    mainProgram = "apparix";
  };
}
