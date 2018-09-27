{ lib, stdenv, steamPackages }:

stdenv.mkDerivation rec {
  name= "steam-udev-${version}";
  version = lib.getVersion steamPackages.steam.name;

  src = steamPackages.steam.src;
 
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
