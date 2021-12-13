{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "uhk-udev-rules";
  version = "20210525";

  # Source: https://raw.githubusercontent.com/UltimateHackingKeyboard/agent/master/rules/50-uhk60.rules
  src = [ ./50-uhk60.rules ];

  dontUnpack = true;

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/50-uhk60.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/UltimateHackingKeyboard/agent";
    description =
      "udev rules that give users permission to program UHK keyboards";
    platforms = platforms.linux;
    license = "unknown";
    maintainers = with maintainers; [ poelzi ];
  };
}
