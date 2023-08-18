{ lib
, autoPatchelfHook
, copyDesktopItems
, fetchFromGitHub
, makeDesktopItem
, stdenv
, alsa-lib
, gcc-unwrapped
, git
, godot3-export-templates
, godot3-headless
, libGLU
, libX11
, libXcursor
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, libglvnd
, libpulseaudio
, perl
, zlib
, udev # for libudev
}:

stdenv.mkDerivation rec {
  pname = "oh-my-git";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "git-learning-game";
    repo = "oh-my-git";
    rev = version;
    sha256 = "sha256-XqxliMVU55D5JSt7Yo5btvZnnTlagSukyhXv6Akgklo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    godot3-headless
  ];

  buildInputs = [
    alsa-lib
    gcc-unwrapped.lib
    git
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    libglvnd
    libpulseaudio
    perl
    zlib
    udev
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "oh-my-git";
      exec = "oh-my-git";
      icon = "oh-my-git";
      desktopName = "oh-my-git";
      comment = "An interactive Git learning game!";
      genericName = "An interactive Git learning game!";
      categories = [ "Game" ];
    })
  ];

  # patch shebangs so that e.g. the fake-editor script works:
  # error: /usr/bin/env 'perl': No such file or directory
  # error: There was a problem with the editor
  postPatch = ''
    patchShebangs scripts
  '';

  buildPhase = ''
    runHook preBuild

    # Cannot create file '/homeless-shelter/.config/godot/projects/...'
    export HOME=$TMPDIR

    # Link the export-templates to the expected location. The --export commands
    # expects the template-file at .../templates/3.2.3.stable/linux_x11_64_release
    # with 3.2.3 being the version of godot.
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    mkdir -p $out/share/oh-my-git
    godot3-headless --export "Linux" $out/share/oh-my-git/oh-my-git

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/share/oh-my-git/oh-my-git $out/bin

    # Patch binaries.
    interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    patchelf \
      --set-interpreter $interpreter \
      --set-rpath ${lib.makeLibraryPath buildInputs} \
      $out/share/oh-my-git/oh-my-git

    mkdir -p $out/share/pixmaps
    cp images/oh-my-git.png $out/share/pixmaps/oh-my-git.png

    runHook postInstall
  '';

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ];

  meta = with lib; {
    homepage = "https://ohmygit.org/";
    description = "An interactive Git learning game";
    license = with licenses; [ blueOak100 ];
    platforms   = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jojosch ];
  };
}
