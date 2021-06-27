{ stdenv, lib, fetchFromGitHub, scons, pkg-config, udev, libX11
, libXcursor , libXinerama, libXrandr, libXrender, libpulseaudio
, libXi, libXext, libXfixes, freetype, openssl
, alsa-lib, libGLU, zlib, yasm
, withUdev ? true
}:

let
  options = {
    touch = libXi != null;
    pulseaudio = false;
    udev = withUdev;
  };
in stdenv.mkDerivation rec {
  pname = "godot4";
  version = "4.0-dev";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = "92f75046378a63b46946e8acbd7c224f027ebfa5";
    sha256 = "sha256:02w5l0vdgk5b8frwkf73dl2gxwhynaq9n6bxkwqhylahv8q59wn9";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    scons udev libX11 libXcursor libXinerama libXrandr libXrender
    libXi libXext libXfixes freetype openssl alsa-lib libpulseaudio
    libGLU zlib yasm
  ];

  patches = [
    ./pkg_config_additions.patch
    ./dont_clobber_environment.patch
  ];

  enableParallelBuilding = true;

  sconsFlags = "target=release_debug platform=x11";
  preConfigure = ''
    sconsFlags+=" ${lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "${k}=${builtins.toJSON v}") options)}"
  '';

  outputs = [ "out" "dev" "man" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot.* $out/bin/godot

    mkdir "$dev"
    cp -r modules/gdnative/include $dev

    mkdir -p "$man/share/man/man6"
    cp misc/dist/linux/godot.6 "$man/share/man/man6/"

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"
    substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot"
  '';

  meta = with lib; {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = licenses.mit;
    platforms   = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ abueide twey ];
  };
}
