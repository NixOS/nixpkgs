{ lib, stdenv, bash, appimage-run }:
let
  uhk-agent-bin = stdenv.mkDerivation rec {
    pname = "uhk-agent-bin";
    version = "1.5.16";
    src = builtins.fetchurl {
      url = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v1.5.16/UHK.Agent-1.5.16-linux-x86_64.AppImage";
      sha256 = "sha256:02569smxbn3fr1nhbj7sg79mwc1zs2y2y3jlzbpbkngdc635z74w";
    };
    phases = [ "installPhase" "patchPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/uhk-agent
      chmod +x $out/bin/uhk-agent
    '';
  };

  script = ''
    #!${bash}/bin/bash

    ${appimage-run}/bin/appimage-run ${uhk-agent-bin}/bin/uhk-agent
  '';
in
stdenv.mkDerivation rec {
  pname = "uhk-agent";
  version = "1.5.16";
  buildInputs = [
    bash
    uhk-agent-bin
    appimage-run
  ];

  phases = [ "buildPhase" "installPhase" "patchPhase" ];

  buildPhase = ''
    echo "${script}" >> uhk-agent
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp uhk-agent $out/bin/uhk-agent
    chmod +x $out/bin/uhk-agent
  '';
}
