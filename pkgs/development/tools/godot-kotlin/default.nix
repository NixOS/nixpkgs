{ stdenv, lib, fetchFromGitHub, scons, pkg-config, udev, libX11, jdk
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
  godot_kotlin_version = "0.2.0-3.3.2";
  godot-kotlin = fetchFromGitHub {
    owner  = "utopia-rise";
    repo   = "godot-kotlin-jvm";
    rev    = "${godot_kotlin_version}";
    sha256 = "1g295gdam6hn4hf94hlvlk337b2hhch2az8yc424y6abq6h5xb1v";
  };

in stdenv.mkDerivation rec {
  pname = "godot-kotlin";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = "${version}-stable";
    sha256 = "0rfm6sbbwzvsn76a8aqagd7cqdzmk8qxphgl89k7y982l9a5sz50";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    scons udev libX11 libXcursor libXinerama libXrandr libXrender jdk
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

  postUnpack = ''
    mkdir $sourceRoot/modules/kotlin_jvm/
    cp -r ${godot-kotlin}/. $sourceRoot/modules/kotlin_jvm
  '';

  postBuild = ''
    echo $JAVA_HOME
    cd modules/kotlin_jvm/harness/tests/
    jlink --add-modules java.base,java.logging,jdk.jdwp.agent,jdk.management.agent --output jre
    ./gradlew build
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

  shellHook = ''
    export JAVA_HOME=${jdk.home}
  '';

  meta = with lib; {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = licenses.mit;
    platforms   = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ twey ];
  };
}
