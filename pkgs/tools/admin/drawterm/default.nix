{ stdenv
, lib
, fetchFrom9Front
, unstableGitUpdater
, installShellFiles
, makeWrapper
, xorg
, darwin
, pkg-config
, wayland-scanner
, pipewire
, wayland
, wayland-protocols
, libxkbcommon
, wlr-protocols
, pulseaudio
, config
}:
let
  plat = if stdenv.targetPlatform.isDarwin then "osx-cocoa" else config;
in

stdenv.mkDerivation {
  pname = "drawterm";
  version = "unstable-2023-08-14";

  src = fetchFrom9Front {
    owner = "plan9front";
    repo = "drawterm";
    rev = "0085f650ef3f481692b52c5389a3483421834998";
    hash = "sha256-AiXyMc9M3dwcyaJe4dKe2ClOAAGH6DgZP7s8pNVrXU8=";
  };

  enableParallelBuilding = true;
  strictDeps = true;
  nativeBuildInputs = [ installShellFiles ] ++ {
    linux = [ pkg-config wayland-scanner ];
    unix = [ makeWrapper ];
    osx-cocoa = [ makeWrapper ];
  }."${plat}" or (throw "unsupported CONF");

  buildInputs = {
    linux = [ pipewire wayland wayland-protocols libxkbcommon wlr-protocols ];
    unix = with xorg; [ libX11 libXt ];
    osx-cocoa = with darwin.apple_sdk.frameworks; [ Metal Cocoa QuartzCore ];
  }."${plat}" or (throw "unsupported CONF");

  makeFlags = [ "CONF=${plat}" ]
    ++ lib.optional (plat == "osx-cocoa") "CC=clang";

  installPhase = {
    linux = ''
      install -Dm755 -t $out/bin/ drawterm
    '';
    unix = ''
      # wrapping the oss output with pulse seems to be the easiest
      mv drawterm drawterm.bin
      install -Dm755 -t $out/bin/ drawterm.bin
      makeWrapper ${pulseaudio}/bin/padsp $out/bin/drawterm --add-flags $out/bin/drawterm.bin
    '';
    osx-cocoa = ''
      mkdir -p $out/{Applications,bin}
      mv drawterm gui-cocoa/drawterm.app/
      mv gui-cocoa/drawterm.app $out/Applications/
      makeWrapper $out/Applications/drawterm.app/drawterm $out/bin/drawterm
    '';
  }."${plat}" or (throw "unsupported CONF") + ''
    installManPage drawterm.1
  '';

  passthru.updateScript = unstableGitUpdater { shallowClone = false; };

  meta = {
    description = "Connect to Plan 9 CPU servers from other operating systems.";
    homepage = "https://drawterm.9front.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luc65r moody ];
    # Use config instead of plat here so drawterm-wayland fails to build for darwin
    platforms = with lib; {
      unix = platforms.all;
      linux = platforms.linux;
    }."${config}" or (throw "unsupported CONF");
  };
}
