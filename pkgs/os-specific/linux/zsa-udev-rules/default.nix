{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsa-udev-rules";
  version = "2.1.3";

  src = ./.;

  # Only copies udevs rules
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp 50-zsa.rules $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    description = "udev rules for ZSA devices";
    license = licenses.mit;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
    homepage = "https://github.com/zsa/wally/wiki/Linux-install#2-create-a-udev-rule-file";
  };
}
