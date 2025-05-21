{ stdenv
, lib
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
, nixosTests
}:

stdenv.mkDerivation {
  pname = "drawterm";
  version = "0-unstable-2024-09-08";

  src = fetchFrom9Front {
    owner = "plan9front";
    repo = "drawterm";
    rev = "877bce095a192ead0e9b6e0d5ce3071482cf0f6e";
    hash = "sha256-s1l7IyWRzaBTtoj71W+Ubmcigw4w7Ypf1Yg44vxN2Qg=";
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

  passthru = {
    updateScript = unstableGitUpdater { shallowClone = false; };
    tests = nixosTests.drawterm;
  };

  meta = with lib; {
    description = "Connect to Plan 9 CPU servers from other operating systems";
    homepage = "https://drawterm.9front.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r moody ];
    platforms = platforms.linux;
    mainProgram = "drawterm";
  };
}
