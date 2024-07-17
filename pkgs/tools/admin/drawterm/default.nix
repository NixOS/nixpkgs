{
  stdenv,
  lib,
  fetchFrom9Front,
  unstableGitUpdater,
  installShellFiles,
  makeWrapper,
  xorg,
  pkg-config,
  wayland-scanner,
  pipewire,
  wayland,
  wayland-protocols,
  libxkbcommon,
  wlr-protocols,
  pulseaudio,
  config,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "drawterm";
  version = "0-unstable-2024-04-23";

  src = fetchFrom9Front {
    owner = "plan9front";
    repo = "drawterm";
    rev = "c0951f2a3182d8b70ffe579bfd9da24c2b86e232";
    hash = "sha256-7y2Mte6R4yeayxdFSFGb9Q5M/GQwqyFb+AW/BFsQeZc=";
  };

  enableParallelBuilding = true;
  strictDeps = true;
  nativeBuildInputs =
    [ installShellFiles ]
    ++ {
      linux = [
        pkg-config
        wayland-scanner
      ];
      unix = [ makeWrapper ];
    }
    ."${config}" or (throw "unsupported CONF");

  buildInputs =
    {
      linux = [
        pipewire
        wayland
        wayland-protocols
        libxkbcommon
        wlr-protocols
      ];
      unix = [
        xorg.libX11
        xorg.libXt
      ];
    }
    ."${config}" or (throw "unsupported CONF");

  # TODO: macos
  makeFlags = [ "CONF=${config}" ];

  installPhase =
    {
      linux = ''
        install -Dm755 -t $out/bin/ drawterm
      '';
      unix = ''
        # wrapping the oss output with pulse seems to be the easiest
        mv drawterm drawterm.bin
        install -Dm755 -t $out/bin/ drawterm.bin
        makeWrapper ${pulseaudio}/bin/padsp $out/bin/drawterm --add-flags $out/bin/drawterm.bin
      '';
    }
    ."${config}" or (throw "unsupported CONF")
    + ''
      installManPage drawterm.1
    '';

  passthru = {
    updateScript = unstableGitUpdater { shallowClone = false; };
    tests = nixosTests.drawterm;
  };

  meta = with lib; {
    description = "Connect to Plan 9 CPU servers from other operating systems";
    homepage = "https://drawterm.9front.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      luc65r
      moody
    ];
    platforms = platforms.linux;
    mainProgram = "drawterm";
  };
}
