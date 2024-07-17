{
  lib,
  stdenv,
  fetchFromGitLab,
  wrapGAppsHook3,
  pkg-config,
  meson,
  ninja,
  cmake,
  gobject-introspection,
  desktop-file-utils,
  python3,
  gtk3,
  libdazzle,
  libappindicator-gtk3,
  libnotify,
  nvidia_x11,
}:

let
  pythonEnv = python3.withPackages (
    pypkgs: with pypkgs; [
      injector
      matplotlib
      peewee
      pynvml
      pygobject3
      xlib
      pyxdg
      requests
      rx
      gtk3
      reactivex
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "gwe";
  version = "0.15.7";

  src = fetchFromGitLab {
    owner = "leinardi";
    repo = pname;
    rev = version;
    sha256 = "sha256-0/VQD3WuSMShsPjydOxVEufBZqVOCTFO3UbJpsy+oLE=";
  };

  prePatch = ''
    patchShebangs scripts/{make_local_manifest,meson_post_install}.py

    substituteInPlace gwe/repository/nvidia_repository.py \
      --replace "from py3nvml import py3nvml" "import pynvml" \
      --replace "py3nvml.py3nvml" "pynvml" \
      --replace "py3nvml" "pynvml"
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    pkg-config
    meson
    ninja
    cmake
    gobject-introspection
    desktop-file-utils
    pythonEnv
  ];

  buildInputs = [
    gtk3
    libdazzle
    libappindicator-gtk3
    libnotify
  ];

  postInstall = ''
    mv $out/bin/gwe $out/lib/gwe-bin

    makeWrapper ${pythonEnv}/bin/python $out/bin/gwe \
      --add-flags "$out/lib/gwe-bin" \
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib" \
      --prefix PATH : "${
        builtins.concatStringsSep ":" [
          (lib.makeBinPath [
            nvidia_x11
            nvidia_x11.settings
          ])
          "/run/wrappers/bin"
        ]
      }" \
      --unset "SHELL" \
      ''${gappsWrapperArgs[@]}
  '';

  meta = with lib; {
    description = "System utility designed to provide information, control the fans and overclock your NVIDIA card";
    homepage = "https://gitlab.com/leinardi/gwe";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "gwe";
  };
}
