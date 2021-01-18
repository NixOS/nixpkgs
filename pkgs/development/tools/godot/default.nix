{ stdenv, lib, fetchFromGitHub, scons, pkgconfig, libX11, libXcursor
, libXinerama, libXrandr, libXrender, libpulseaudio ? null
, libXi ? null, libXext, libXfixes, freetype, openssl
, alsaLib, libGLU, zlib, yasm ? null
, withMono ? false, mono, msbuild, godot, fetchurl, makeWrapper, dotnetPackages }:

let
  options = {
    touch = libXi != null;
    pulseaudio = false;
  } // lib.optionalAttrs withMono {
    module_mono_enabled = "yes";
    mono_static = "yes";
    mono_prefix = mono;
  };
in stdenv.mkDerivation rec {
  pname = "godot";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = "${version}-stable";
    sha256 = "19vrp5lhyvxbm6wjxzn28sn3i0s8j08ca7nani8l1nrhvlc8wi0v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    scons libX11 libXcursor libXinerama libXrandr libXrender
    libXi libXext libXfixes freetype openssl alsaLib libpulseaudio
    libGLU zlib yasm
  ] ++ lib.optionals withMono [ dotnetPackages.Nuget makeWrapper msbuild ];

  patches = [
    ./pkg_config_additions.patch
    ./dont_clobber_environment.patch
  ];

  enableParallelBuilding = true;

  sconsFlags = "target=release_debug platform=x11";
  preConfigure = ''
    sconsFlags+=" ${lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "${k}=${builtins.toJSON v}") options)}"
  '';

  preBuild = let
    monoDeps = import ./mono-deps.nix { inherit fetchurl; };

    # Create a temporary Godot binary to generate mono glue code.
    monoGlueGenerator = godot.overrideAttrs (oldAttrs: rec {
      sconsFlags = "target=release_debug platform=server tools=yes module_mono_enabled=yes mono_glue=no mono_static=yes mono_prefix=${mono}";
      outputs = [ "out" ];
      installPhase = "mkdir -p $out/bin && cp bin/* $out/bin";
    });
  in lib.optionalString withMono ''
    ${monoGlueGenerator}/bin/godot_server.x11.opt.tools.*.mono --generate-mono-glue modules/mono/glue

    # Set a fake HOME for NuGet otherwise it gets denied permission trying to access "/homeless-shelter".
    export HOME=$(pwd)/fake-home

    # Add our pre-fetched nuget packages to the "nixos" source.
    for package in ${toString monoDeps}; do
      nuget add $package -Source nixos
    done

    # Ensure msbuild will only restore packages from the "nixos" source,
    # otherwise msbuild will try to connect to online sources and fail.
    echo "/p:RestoreSources=nixos" > modules/mono/glue/GodotSharp/MSBuild.rsp
    echo "/p:RestoreSources=nixos" > modules/mono/editor/GodotTools/MSBuild.rsp
  '';

  outputs = [ "out" "dev" "man" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot.* $out/bin/godot
    ${lib.optionalString withMono "cp -r bin/GodotSharp $out/bin"}

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

  postFixup = lib.optionalString withMono ''
    wrapProgram $out/bin/godot --prefix PATH : ${msbuild}/bin
  '';

  meta = with stdenv.lib; {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = licenses.mit;
    platforms   = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ twey lihop ];
  };
}
