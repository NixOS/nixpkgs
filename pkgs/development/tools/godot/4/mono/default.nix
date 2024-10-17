{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoPatchelfHook
, installShellFiles
, scons
, python3
, mkNugetDeps
, mkNugetSource
, writeText
, vulkan-loader
, libGL
, libX11
, libXcursor
, libXinerama
, libXext
, libXrandr
, libXrender
, libXi
, libXfixes
, libxkbcommon
, alsa-lib
, libpulseaudio
, dbus
, speechd
, fontconfig
, udev
, withPlatform ? "linuxbsd"
, withTarget ? "editor"
, withPrecision ? "single"
, withPulseaudio ? true
, withDbus ? true
, withSpeechd ? true
, withFontconfig ? true
, withUdev ? true
, withTouch ? true
, dotnet-sdk
, mono
, dotnet-runtime
, callPackage
}:

assert lib.asserts.assertOneOf "withPrecision" withPrecision [ "single" "double" ];

let
  mkSconsFlagsFromAttrSet = lib.mapAttrsToList (k: v:
    if builtins.isString v
    then "${k}=${v}"
    else "${k}=${builtins.toJSON v}");
in
stdenv.mkDerivation rec {
  pname = "godot4-mono";
  version = "4.2.1-stable";
  commitHash = "b09f793f564a6c95dc76acc654b390e68441bd01";

  nugetDeps = mkNugetDeps { name = "deps"; nugetDeps = import ./deps.nix; };

  shouldConfigureNuget = true;

  nugetSource =
    mkNugetSource {
      name = "${pname}-nuget-source";
      description = "A Nuget source with dependencies for ${pname}";
      deps = [ nugetDeps ];
  };

  nugetConfig = writeText "NuGet.Config" ''
    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <packageSources>
        <add key="${pname}-deps" value="${nugetSource}/lib" />
      </packageSources>
    </configuration>
  '';

  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
    rev = commitHash;
    hash = "sha256-Q6Og1H4H2ygOryMPyjm6kzUB6Su6T9mJIp0alNAxvjQ";
  };

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    installShellFiles
    python3
    mono
    dotnet-sdk
    dotnet-runtime
  ];

  buildInputs = [
    scons
  ];

  runtimeDependencies = [
    vulkan-loader
    libGL
    libX11
    libXcursor
    libXinerama
    libXext
    libXrandr
    libXrender
    libXi
    libXfixes
    libxkbcommon
    alsa-lib
    mono
    dotnet-sdk
    dotnet-runtime
  ]
  ++ lib.optional withPulseaudio libpulseaudio
  ++ lib.optional withDbus dbus
  ++ lib.optional withDbus dbus.lib
  ++ lib.optional withSpeechd speechd
  ++ lib.optional withFontconfig fontconfig
  ++ lib.optional withFontconfig fontconfig.lib
  ++ lib.optional withUdev udev;

  enableParallelBuilding = true;

  # Set the build name which is part of the version. In official downloads, this
  # is set to 'official'. When not specified explicitly, it is set to
  # 'custom_build'. Other platforms packaging Godot (Gentoo, Arch, Flatpack
  # etc.) usually set this to their name as well.
  #
  # See also 'methods.py' in the Godot repo and 'build' in
  # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
  BUILD_NAME = "nixpkgs";

  # Required for the commit hash to be included in the version number.
  #
  # `methods.py` reads the commit hash from `.git/HEAD` and manually follows
  # refs. Since we just write the hash directly, there is no need to emulate any
  # other parts of the .git directory.
  #
  # See also 'hash' in
  # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
  preConfigure = ''
    mkdir -p .git
    echo ${commitHash} > .git/HEAD
  '';

  outputs = [ "out" "man" ];

  postConfigure = ''
    echo "Setting up buildhome."
    mkdir buildhome
    export HOME="$PWD"/buildhome

    if [ -n "$shouldConfigureNuget" ]; then
      echo "Configuring NuGet."
      mkdir -p ~/.nuget/NuGet
      ln -s "$nugetConfig" ~/.nuget/NuGet/NuGet.Config
    fi
  '';

  buildPhase = ''
    echo "Starting Build"
    scons p=${withPlatform} target=${withTarget} precision=${withPrecision} module_mono_enabled=yes mono_glue=no

    echo "Generating Glue"
    if [[ ${withPrecision} == *double* ]]; then
        bin/godot.${withPlatform}.${withTarget}.${withPrecision}.x86_64.mono --headless --generate-mono-glue modules/mono/glue
    else
        bin/godot.${withPlatform}.${withTarget}.x86_64.mono --headless --generate-mono-glue modules/mono/glue
    fi

    echo "Building Assemblies"
    scons p=${withPlatform} target=${withTarget} precision=${withPrecision} module_mono_enabled=yes mono_glue=yes

    echo "Building C#/.NET Assemblies"
    python modules/mono/build_scripts/build_assemblies.py --godot-output-dir bin --precision=${withPrecision}
    '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot.* $out/bin/godot4-mono
    cp -r bin/GodotSharp/ $out/bin/

    installManPage misc/dist/linux/godot.6

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/org.godotengine.Godot4-Mono.desktop"
    substituteInPlace "$out/share/applications/org.godotengine.Godot4-Mono.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot4-mono" \
      --replace "Godot Engine" "Godot Engine ${version} (Mono, $(echo "${withPrecision}" | sed 's/.*/\u&/') Precision)"
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"
    '';

  meta = with lib; {
    homepage = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ ilikefrogs101 ];
    mainProgram = "godot4-mono";
  };

  passthru = {
    make-deps = callPackage ./make-deps.nix {};
  };
}

