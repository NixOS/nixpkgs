{
  alsa-lib,
  autoPatchelfHook,
  buildPackages,
  callPackage,
  dbus,
  dotnetCorePackages,
  exportTemplatesHash,
  fetchFromGitHub,
  fetchpatch,
  fontconfig,
  glib,
  hash,
  installShellFiles,
  lib,
  libdecor,
  libGL,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libxkbcommon,
  libXrandr,
  libXrender,
  makeWrapper,
  perl,
  pkg-config,
  runCommand,
  scons,
  speechd-minimal,
  stdenv,
  stdenvNoCC,
  testers,
  udev,
  updateScript,
  version,
  vulkan-loader,
  wayland,
  wayland-scanner,
  withAlsa ? true,
  withDbus ? true,
  withFontconfig ? true,
  withMono ? false,
  nugetDeps ? null,
  withPlatform ? "linuxbsd",
  withPrecision ? "single",
  withPulseaudio ? true,
  withSpeechd ? true,
  withTouch ? true,
  withUdev ? true,
  # Wayland in Godot requires X11 until upstream fix is merged
  # https://github.com/godotengine/godot/pull/73504
  withWayland ? true,
  withX11 ? true,
}:
assert lib.asserts.assertOneOf "withPrecision" withPrecision [
  "single"
  "double"
];
let
  mkSconsFlagsFromAttrSet = lib.mapAttrsToList (
    k: v: if builtins.isString v then "${k}=${v}" else "${k}=${builtins.toJSON v}"
  );

  arch = stdenv.hostPlatform.linuxArch;

  dotnet-sdk = dotnetCorePackages.sdk_8_0-source;

  dottedVersion = lib.replaceStrings [ "-" ] [ "." ] version + lib.optionalString withMono ".mono";

  attrsForTarget =
    target: finalAttrs:
    let
      editor = target == "editor";
      suffix = lib.optionalString withMono "-mono" + lib.optionalString (!editor) "-template";
      binary = lib.concatStringsSep "." (
        [
          "godot"
          withPlatform
          target
        ]
        ++ lib.optional (withPrecision != "single") withPrecision
        ++ [ arch ]
        ++ lib.optional withMono "mono"
      );
    in
    rec {
      pname = "godot${suffix}";
      inherit version;

      src = fetchFromGitHub {
        owner = "godotengine";
        repo = "godot";
        tag = version;
        inherit hash;
        # Required for the commit hash to be included in the version number.
        #
        # `methods.py` reads the commit hash from `.git/HEAD` and manually follows
        # refs.
        #
        # See also 'hash' in
        # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
        leaveDotGit = true;
        # Only keep HEAD, because leaveDotGit is non-deterministic:
        # https://github.com/NixOS/nixpkgs/issues/8567
        postFetch = ''
          hash=$(git -C "$out" rev-parse HEAD)
          rm -r "$out"/.git
          mkdir "$out"/.git
          echo "$hash" > "$out"/.git/HEAD
        '';
      };

      outputs = [
        "out"
      ]
      ++ lib.optional editor "man";
      separateDebugInfo = true;

      # Set the build name which is part of the version. In official downloads, this
      # is set to 'official'. When not specified explicitly, it is set to
      # 'custom_build'. Other platforms packaging Godot (Gentoo, Arch, Flatpack
      # etc.) usually set this to their name as well.
      #
      # See also 'methods.py' in the Godot repo and 'build' in
      # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
      BUILD_NAME = "nixpkgs";

      preConfigure = lib.optionalString withMono ''
        # TODO: avoid pulling in dependencies of windows-only project
        dotnet sln modules/mono/editor/GodotTools/GodotTools.sln \
          remove modules/mono/editor/GodotTools/GodotTools.OpenVisualStudio/GodotTools.OpenVisualStudio.csproj

        dotnet restore modules/mono/glue/GodotSharp/GodotSharp.sln
        dotnet restore modules/mono/editor/GodotTools/GodotTools.sln
        dotnet restore modules/mono/editor/Godot.NET.Sdk/Godot.NET.Sdk.sln
      '';

      # From: https://github.com/godotengine/godot/blob/4.2.2-stable/SConstruct
      sconsFlags = mkSconsFlagsFromAttrSet {
        # Options from 'SConstruct'
        precision = withPrecision; # Floating-point precision level
        production = true; # Set defaults to build Godot for use in production
        platform = withPlatform;
        inherit target;
        debug_symbols = true;

        # Options from 'platform/linuxbsd/detect.py'
        alsa = withAlsa;
        dbus = withDbus; # Use D-Bus to handle screensaver and portal desktop settings
        fontconfig = withFontconfig; # Use fontconfig for system fonts support
        pulseaudio = withPulseaudio; # Use PulseAudio
        speechd = withSpeechd; # Use Speech Dispatcher for Text-to-Speech support
        touch = withTouch; # Enable touch events
        udev = withUdev; # Use udev for gamepad connection callbacks
        wayland = withWayland; # Compile with Wayland support
        x11 = withX11; # Compile with X11 support

        module_mono_enabled = withMono;

        # aliasing bugs exist with hardening+LTO
        # https://github.com/godotengine/godot/pull/104501
        ccflags = "-fno-strict-aliasing";
        linkflags = "-Wl,--build-id";

        use_sowrap = false;
      };

      enableParallelBuilding = true;

      strictDeps = true;

      patches = lib.optionals (lib.versionOlder version "4.4") [
        (fetchpatch {
          name = "wayland-header-fix.patch";
          url = "https://github.com/godotengine/godot/commit/6ce71f0fb0a091cffb6adb4af8ab3f716ad8930b.patch";
          hash = "sha256-hgAtAtCghF5InyGLdE9M+9PjPS1BWXWGKgIAyeuqkoU=";
        })
        # Fix a crash in the mono test project build. It no longer seems to
        # happen in 4.4, but an existing fix couldn't be identified.
        ./CSharpLanguage-fix-crash-in-reload_assemblies-after-.patch
      ];

      postPatch = ''
        # this stops scons from hiding e.g. NIX_CFLAGS_COMPILE
        perl -pi -e '{ $r += s:(env = Environment\(.*):\1\nenv["ENV"] = os.environ: } END { exit ($r != 1) }' SConstruct

        substituteInPlace thirdparty/glad/egl.c \
          --replace-fail \
            'static const char *NAMES[] = {"libEGL.so.1", "libEGL.so"}' \
            'static const char *NAMES[] = {"${lib.getLib libGL}/lib/libEGL.so"}'

        substituteInPlace thirdparty/glad/gl.c \
          --replace-fail \
            'static const char *NAMES[] = {"libGLESv2.so.2", "libGLESv2.so"}' \
            'static const char *NAMES[] = {"${lib.getLib libGL}/lib/libGLESv2.so"}' \

        substituteInPlace thirdparty/glad/gl{,x}.c \
          --replace-fail \
            '"libGL.so.1"' \
            '"${lib.getLib libGL}/lib/libGL.so"'

        substituteInPlace thirdparty/volk/volk.c \
          --replace-fail \
            'dlopen("libvulkan.so.1"' \
            'dlopen("${lib.getLib vulkan-loader}/lib/libvulkan.so"'
      '';

      depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
        buildPackages.stdenv.cc
        pkg-config
      ];

      buildInputs =
        lib.optionals withMono dotnet-sdk.packages
        ++ lib.optional withAlsa alsa-lib
        ++ lib.optional (withX11 || withWayland) libxkbcommon
        ++ lib.optionals withX11 [
          libX11
          libXcursor
          libXext
          libXfixes
          libXi
          libXinerama
          libXrandr
          libXrender
        ]
        ++ lib.optionals withWayland [
          # libdecor
          wayland
        ]
        ++ lib.optionals withDbus [
          dbus
        ]
        ++ lib.optionals withFontconfig [
          fontconfig
        ]
        ++ lib.optional withPulseaudio libpulseaudio
        ++ lib.optionals withSpeechd [
          speechd-minimal
          glib
        ]
        ++ lib.optional withUdev udev;

      nativeBuildInputs = [
        installShellFiles
        perl
        pkg-config
        scons
      ]
      ++ lib.optionals withWayland [ wayland-scanner ]
      ++ lib.optionals withMono [
        dotnet-sdk
        makeWrapper
      ];

      postBuild = lib.optionalString (editor && withMono) ''
        echo "Generating Glue"
        bin/${binary} --headless --generate-mono-glue modules/mono/glue
        echo "Building C#/.NET Assemblies"
        python modules/mono/build_scripts/build_assemblies.py --godot-output-dir bin --precision=${withPrecision}
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out"/{bin,libexec}
        cp -r bin/* "$out"/libexec

        cd "$out"/bin
        ln -s ../libexec/${binary} godot${lib.versions.majorMinor version}${suffix}
        ln -s godot${lib.versions.majorMinor version}${suffix} godot${lib.versions.major version}${suffix}
        ln -s godot${lib.versions.major version}${suffix} godot${suffix}
        cd -
      ''
      + (
        if editor then
          ''
            installManPage misc/dist/linux/godot.6

            mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
            cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/org.godotengine.Godot${lib.versions.majorMinor version}${suffix}.desktop"
            substituteInPlace "$out/share/applications/org.godotengine.Godot${lib.versions.majorMinor version}${suffix}.desktop" \
              --replace "Exec=godot" "Exec=$out/bin/godot${suffix}" \
              --replace "Godot Engine" "Godot Engine ${
                lib.versions.majorMinor version + lib.optionalString withMono " (Mono)"
              }"
            cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
            cp icon.png "$out/share/icons/godot.png"
          ''
          + lib.optionalString withMono ''
            mkdir -p "$out"/share/nuget
            mv "$out"/libexec/GodotSharp/Tools/nupkgs "$out"/share/nuget/source

            wrapProgram $out/libexec/${binary} \
              --set DOTNET_ROOT ${dotnet-sdk}/share/dotnet \
              --prefix PATH : "${
                lib.makeBinPath [
                  dotnet-sdk
                ]
              }"
          ''
        else
          let
            template =
              (lib.replaceStrings
                [ "template" ]
                [
                  {
                    linuxbsd = "linux";
                  }
                  .${withPlatform}
                ]
                target
              )
              + "."
              + arch;
          in
          ''
            templates="$out"/share/godot/export_templates/${dottedVersion}
            mkdir -p "$templates"
            ln -s "$out"/libexec/${binary} "$templates"/${template}
          ''
      )
      + ''
        runHook postInstall
      '';

      passthru = {
        inherit updateScript;

        tests = {
          version = testers.testVersion {
            package = finalAttrs.finalPackage;
            version = dottedVersion;
          };
        }
        // lib.optionalAttrs editor (
          let
            pkg = finalAttrs.finalPackage;

            project-src = runCommand "${pkg.name}-project-src" { } (
              ''
                mkdir "$out"
                cd "$out"
                touch project.godot

                cat >create-scene.gd <<'EOF'
                extends SceneTree

                func _initialize():
                  var node = Node.new()
                  var script = ResourceLoader.load("res://test.gd")
                  node.set_script(script)
              ''
              + lib.optionalString withMono ''
                ${""}
                  var monoNode = Node.new()
                  var monoScript = ResourceLoader.load("res://Test.cs")
                  monoNode.set_script(monoScript)
                  node.add_child(monoNode)
                  monoNode.owner = node
              ''
              + ''
                  var scene = PackedScene.new()
                  var scenePath = "res://test.tscn"
                  scene.pack(node)
                  node.free()
                  var x = ResourceSaver.save(scene, scenePath)
                  ProjectSettings["application/run/main_scene"] = scenePath
                  ProjectSettings.save()
                  quit()
                EOF

                cat >test.gd <<'EOF'
                extends Node
                func _ready():
                  print("Hello, World!")
                  get_tree().quit()
                EOF

                cat >export_presets.cfg <<'EOF'
                [preset.0]
                name="build"
                platform="Linux"
                runnable=true
                export_filter="all_resources"
                include_filter=""
                exclude_filter=""
                [preset.0.options]
                binary_format/architecture="${arch}"
                EOF
              ''
              + lib.optionalString withMono ''
                cat >Test.cs <<'EOF'
                using Godot;
                using System;

                public partial class Test : Node
                {
                  public override void _Ready()
                  {
                    GD.Print("Hello, Mono!");
                    GetTree().Quit();
                  }
                }
                EOF

                sdk_version=$(basename ${pkg}/share/nuget/packages/godot.net.sdk/*)
                cat >UnnamedProject.csproj <<EOF
                <Project Sdk="Godot.NET.Sdk/$sdk_version">
                  <PropertyGroup>
                    <TargetFramework>net8.0</TargetFramework>
                    <EnableDynamicLoading>true</EnableDynamicLoading>
                  </PropertyGroup>
                </Project>
                EOF
              ''
            );

            export-tests = lib.makeExtensible (final: {
              inherit (pkg) export-template;

              export = stdenvNoCC.mkDerivation {
                name = "${final.export-template.name}-export";

                nativeBuildInputs = [
                  pkg
                ]
                ++ lib.optional withMono dotnet-sdk;

                src = project-src;

                postConfigure = lib.optionalString withMono ''
                  dotnet new sln -n UnnamedProject
                  message=$(dotnet sln add UnnamedProject.csproj)
                  echo "$message"
                  # dotnet sln doesn't return an error when it fails to add the project
                  [[ $message == "Project \`UnnamedProject.csproj\` added to the solution." ]]
                '';

                exportTemplate = pkg.export-template;

                buildPhase = ''
                  runHook preBuild

                  export HOME=$(mktemp -d)
                  mkdir -p $HOME/.local/share/godot/
                  ln -s "${final.export-template}"/share/godot/export_templates "$HOME"/.local/share/godot/

                  godot${suffix} --headless --build-solutions -s create-scene.gd

                  runHook postBuild
                '';

                installPhase = ''
                  runHook preInstall

                  mkdir -p "$out"/bin
                  godot${suffix} --headless --export-release build "$out"/bin/test

                  runHook postInstall
                '';
              };

              run = runCommand "${final.export.name}-runs" { passthru = { inherit (final) export; }; } (
                ''
                  (
                    set -eo pipefail
                    HOME=$(mktemp -d)
                    "${final.export}"/bin/test --headless | tail -n+3 | (
                ''
                + lib.optionalString withMono ''
                  # indent
                      read output
                      if [[ "$output" != "Hello, Mono!" ]]; then
                        echo "unexpected output: $output" >&2
                        exit 1
                      fi
                ''
                + ''
                      read output
                      if [[ "$output" != "Hello, World!" ]]; then
                        echo "unexpected output: $output" >&2
                        exit 1
                      fi
                    )
                    touch "$out"
                  )
                ''
              );
            });

          in
          {
            export-runs = export-tests.run;

            export-bin-runs =
              (export-tests.extend (
                final: prev: {
                  export-template = pkg.export-templates-bin;

                  export = prev.export.overrideAttrs (prev: {
                    nativeBuildInputs = prev.nativeBuildInputs or [ ] ++ [
                      autoPatchelfHook
                    ];

                    # stripping dlls results in:
                    # Failed to load System.Private.CoreLib.dll (error code 0x8007000B)
                    stripExclude = lib.optional withMono [ "*.dll" ];

                    runtimeDependencies =
                      prev.runtimeDependencies or [ ]
                      ++ map lib.getLib [
                        alsa-lib
                        libpulseaudio
                        libX11
                        libXcursor
                        libXext
                        libXi
                        libXrandr
                        udev
                        vulkan-loader
                      ];
                  });
                }
              )).run;
          }
        );
      }
      // lib.optionalAttrs editor {
        export-template = mkTarget "template_release";
        export-templates-bin = (
          callPackage ./export-templates-bin.nix {
            inherit version withMono;
            godot = finalAttrs.finalPackage;
            hash = exportTemplatesHash;
          }
        );
      };

      requiredSystemFeatures = [
        # fixes: No space left on device
        "big-parallel"
      ];

      meta = {
        changelog = "https://github.com/godotengine/godot/releases/tag/${version}";
        description = "Free and Open Source 2D and 3D game engine";
        homepage = "https://godotengine.org";
        license = lib.licenses.mit;
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
        ]
        ++ lib.optional (!withMono) "i686-linux";
        maintainers = with lib.maintainers; [
          shiryel
          corngood
        ];
        mainProgram = "godot${suffix}";
      };
    };

  mkTarget =
    target:
    let
      attrs = attrsForTarget target;
    in
    stdenv.mkDerivation (
      if withMono then
        dotnetCorePackages.addNuGetDeps {
          inherit nugetDeps;
          overrideFetchAttrs = old: rec {
            runtimeIds = map (system: dotnetCorePackages.systemToDotnetRid system) old.meta.platforms;
            buildInputs =
              old.buildInputs
              ++ lib.concatLists (lib.attrValues (lib.getAttrs runtimeIds dotnet-sdk.targetPackages));
          };
        } attrs
      else
        attrs
    );
in
mkTarget "editor"
