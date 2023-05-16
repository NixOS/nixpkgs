{ stdenv
, lib
<<<<<<< HEAD
, fetchFrom9Front
, unstableGitUpdater
, installShellFiles
, makeWrapper
, xorg
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

stdenv.mkDerivation {
  pname = "drawterm";
  version = "unstable-2023-08-22";

  src = fetchFrom9Front {
    owner = "plan9front";
    repo = "drawterm";
    rev = "c91c6fac9d725716ca6ecc3002053f941137f24f";
    hash = "sha256-oGcKRx1tP2jeshHhaCHPRKmwKQ3WPYK1tHGGt1/3oDU=";
  };

  enableParallelBuilding = true;
  strictDeps = true;
  nativeBuildInputs = [ installShellFiles ] ++ {
    linux = [ pkg-config wayland-scanner ];
    unix = [ makeWrapper ];
  }."${config}" or (throw "unsupported CONF");

  buildInputs = {
    linux = [ pipewire wayland wayland-protocols libxkbcommon wlr-protocols ];
    unix = [ xorg.libX11 xorg.libXt ];
  }."${config}" or (throw "unsupported CONF");

  # TODO: macos
  makeFlags = [ "CONF=${config}" ];

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
  }."${config}" or (throw "unsupported CONF") + ''
    installManPage drawterm.1
  '';

  passthru.updateScript = unstableGitUpdater { shallowClone = false; };

  meta = with lib; {
    description = "Connect to Plan 9 CPU servers from other operating systems.";
    homepage = "https://drawterm.9front.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r moody ];
    platforms = platforms.linux;
    mainProgram = "drawterm";
=======
, fetchgit
, xorg
}:

stdenv.mkDerivation rec {
  pname = "drawterm";
  version = "unstable-2023-03-05";

  src = fetchgit {
    url = "git://git.9front.org/plan9front/drawterm";
    rev = "ed9cff5a4c39322744c4708699c9ae6651b7c9ab";
    sha256 = "LM6UnggoxKC3e6xOlHYk9VFF99Abbdmp37nuUML8RgI=";
  };

  buildInputs = [
    xorg.libX11
    xorg.libXt
  ];

  # TODO: macos
  makeFlags = [ "CONF=unix" ];

  installPhase = ''
    install -Dm755 -t $out/bin/ drawterm
    install -Dm644 -t $out/man/man1/ drawterm.1
  '';

  meta = with lib; {
    description = "Connect to Plan9 CPU servers from other operating systems.";
    homepage = "https://drawterm.9front.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
