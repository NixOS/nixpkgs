{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsa-udev-rules";
  version = "unstable-2022-10-26";

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally";
    rev = "623a50d0e0b90486e42ad8ad42b0a7313f7a37b3";
    hash = "sha256-meR2V7T4hrJFXFPLENHoAgmOILxxynDBk0BLqzsAZvQ=";
  };

  # Only copies udevs rules
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp dist/linux64/50-oryx.rules $out/lib/udev/rules.d/
    cp dist/linux64/50-wally.rules $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    description = "udev rules for ZSA devices";
    license = licenses.mit;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
    homepage = "https://github.com/zsa/wally/wiki/Linux-install#2-create-a-udev-rule-file";
  };
}
