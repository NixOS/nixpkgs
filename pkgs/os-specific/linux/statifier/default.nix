{ lib, multiStdenv, fetchurl }:

multiStdenv.mkDerivation rec {
  pname = "statifier";
  version = "1.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/statifier/statifier-${version}.tar.gz";
    sha256 = "03lzkla6knjhh186b43cac410x2fmhi28pkmzb3d211n3zp5i9y8";
  };

  phaseNames = [ "patchPhase" "installPhase" ];

  postPatch = ''
    sed -e s@/usr/@"$out/"@g -i */Makefile src/statifier
    sed -e s@/bin/bash@"${multiStdenv.shell}"@g -i src/*.sh
  '';

  meta = with lib; {
    description = "Tool for creating static Linux binaries";
    mainProgram = "statifier";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
