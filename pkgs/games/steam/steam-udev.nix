{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name= "steam-udev-${version}";
  version = "1.0.0.56";

  src = fetchurl {
    url = "http://repo.steampowered.com/steam/pool/steam/s/steam/steam_${version}.tar.gz"; 
    sha256 = "01jgp909biqf4rr56kb08jkl7g5xql6r2g4ch6lc71njgcsbn5fs";
  };
 
  installPhase = ''
    install -d $out/lib/udev/rules.d
    install -m644 lib/udev/rules.d/*.rules $out/lib/udev/rules.d
  '';

  meta = with stdenv.lib; {
    description = "udev rules for Steam hardware: Steam Controller and HTC Vive";
    maintainers = with maintainers; [ nyanloutre ];
    license = licenses.unfreeRedistributable;
  };
}
