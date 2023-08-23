{ lib
, buildDotnetModule
, fetchFromGitHub
, wayland
, libglvnd
, glfw-wayland
}:

buildDotnetModule {
  pname = "wlxmirror";
  version = "2023-07-05";

  nugetDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "galister";
    repo = "wlxmirror";
    rev = "c708e3b8780c3c35b49ea5468b7fbead84a56896";
    hash = "sha256-5zZZ3xL+k+QyZZrjMwBjJlj7UR4bBOxicMqDFFknNkU=";
  };

  postFixup = ''
    wrapProgram $out/bin/WlxMirror \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland libglvnd glfw-wayland ]}

    # Make lowercase executable
    ln -s $out/bin/WlxMirror $out/bin/wlxmirror
  '';

  meta = {
    description = "Display your screen in a window and pass mouse events";
    homepage = "https://github.com/galister/wlxmirror";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
