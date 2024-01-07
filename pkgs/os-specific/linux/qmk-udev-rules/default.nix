{ lib, stdenv, fetchFromGitHub }:

## Usage
# In NixOS, set hardware.keyboard.qmk.enable = true;

stdenv.mkDerivation rec {
  pname = "qmk-udev-rules";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_firmware";
    rev = version;
    hash = "sha256-dFc6S9x7sBYZAQn0coZJpmGz66Fx0l4rrexjyB4k0zA=";
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
