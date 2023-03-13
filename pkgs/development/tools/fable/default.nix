# copied from fsautocomplete until https://github.com/NixOS/nixpkgs/issues/216285 is resolved
{ buildDotnetModule, mkNugetDeps, emptyFile, lib, dotnet-sdk }:
let
  fable = buildDotnetModule rec {
    pname = "fable";
    version = "4.1.4";
    inherit dotnet-sdk;
    nugetDeps = mkNugetDeps {
      name = pname;
      nugetDeps = { fetchNuGet }: [
        (fetchNuGet { inherit pname version; sha256 = "sha256-9wMQj4+xmAprt80slet2wUW93fRyEhOhhNVGYbWGS3Y="; })
      ];
    };
    dontUnpack = true;
    dontInstall = true;
    useSdkAsRuntime = true;
    configurePhase = ''
      # Generate a NuGet.config file to make sure everything,
      # including things like <Sdk /> dependencies, is restored from the proper source
      cat <<EOF > "./NuGet.config"
      <?xml version="1.0" encoding="utf-8"?>
      <configuration>
        <packageSources>
          <clear />
          <add key="nugetSource" value="${fable.passthru.nuget-source}/lib" />
        </packageSources>
      </configuration>
      EOF
    '';

    executables = ".dotnet/tools/${pname}";
    buildPhase = ''
      #set env variable to install tool where fixupHook will be able to find it
      export DOTNET_CLI_HOME=$out/lib/${pname}
      dotnet tool install --configfile ./NuGet.config --global ${pname} --version ${version}

      cd $out
      #removing text files that contains nix store paths to temp nuget sources we made
      find . -name 'project.assets.json' -delete
      find . -name '.nupkg.metadata' -delete
    '';

    meta = with lib; {
      description = "Fable is an F# to JavaScript compiler";
      homepage = "https://github.com/fable-compiler/fable";
      changelog = "https://github.com/fable-compiler/fable/releases/tag/v${version}";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ anpin ];
    };
  };
in
fable
