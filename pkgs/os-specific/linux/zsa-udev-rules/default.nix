{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsa-udev-rules";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally";
    rev = "${version}-linux";
    sha256 = "mZzXKFKlO/jAitnqzfvmIHp46A+R3xt2gOhVC3qN6gM=";
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
