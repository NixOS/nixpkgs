{ lib
, stdenv
}:
## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.opensk-udev-rules ];
stdenv.mkDerivation rec {
  pname = "opensk-udev-rules";
  version = "ctap2.0";
  udevRules = ./55-opensk.rules;
  dontUnpack = true;

  installPhase = ''
    install -Dm 644 "${udevRules}" $out/lib/udev/rules.d/55-opensk.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/google/OpenSK";
    description = "Official OpenSK udev rules list";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ oluceps ];
  };
}
