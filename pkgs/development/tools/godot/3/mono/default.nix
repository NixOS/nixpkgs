{
  godot3,
  callPackage,
  mkNugetDeps,
  mkNugetSource,
  mono,
  dotnet-sdk,
  writeText,
}:

godot3.overrideAttrs (
  self: base: {
    pname = "godot3-mono";

    godotBuildDescription = "mono build";

    nativeBuildInputs = base.nativeBuildInputs ++ [
      mono
      dotnet-sdk
    ];

    glue = callPackage ./glue.nix { };

    nugetDeps = mkNugetDeps {
      name = "deps";
      nugetDeps = import ./deps.nix;
    };

    nugetSource = mkNugetSource {
      name = "${self.pname}-nuget-source";
      description = "A Nuget source with dependencies for ${self.pname}";
      deps = [ self.nugetDeps ];
    };

    nugetConfig = writeText "NuGet.Config" ''
      <?xml version="1.0" encoding="utf-8"?>
      <configuration>
        <packageSources>
          <add key="${self.pname}-deps" value="${self.nugetSource}/lib" />
        </packageSources>
      </configuration>
    '';

    sconsFlags = base.sconsFlags ++ [
      "module_mono_enabled=true"
      "mono_prefix=${mono}"
    ];

    shouldConfigureNuget = true;

    postConfigure = ''
      echo "Setting up buildhome."
      mkdir buildhome
      export HOME="$PWD"/buildhome

      echo "Overlaying godot glue."
      cp -R --no-preserve=mode "$glue"/. .

      if [ -n "$shouldConfigureNuget" ]; then
        echo "Configuring NuGet."
        mkdir -p ~/.nuget/NuGet
        ln -s "$nugetConfig" ~/.nuget/NuGet/NuGet.Config
      fi
    '';

    installedGodotShortcutFileName = "org.godotengine.GodotMono3.desktop";
    installedGodotShortcutDisplayName = "Godot Engine (Mono) 3";

    passthru = {
      make-deps = callPackage ./make-deps.nix { };
    };
  }
)
