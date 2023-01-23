{ lib, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "polytopes_db";
  version = "20170220";

  src = fetchurl {
    url = "mirror://sageupstream/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1q0cd811ilhax4dsj9y5p7z8prlalqr7k9mzq178c03frbgqny6b";
  };

  installPhase = ''
    mkdir -p "$out/share/reflexive_polytopes"
    cp -R * "$out/share/reflexive_polytopes/"
  '';

  meta = with lib; {
    description = "Reflexive polytopes database";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = teams.sage.members;
  };
}
