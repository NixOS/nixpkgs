{ lib, stdenv, fetchFromGitHub }:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.qmk-udev-rules ];

stdenv.mkDerivation rec {
  pname = "qmk-udev-rules";
  version = "0.15.25";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_firmware";
    rev = version;
    sha256 = "4U1/9DgoKZ1Al76lZ2P8x4LIvtqaJPLq81cCSCy+9iE=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D util/udev/50-qmk.rules $out/lib/udev/rules.d/50-qmk.rules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/qmk/qmk_firmware";
    description = "Official QMK udev rules list";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ekleog ];
  };
}
