# copied from fsautocomplete until https://github.com/NixOS/nixpkgs/issues/216285 is resolved
{ buildDotnetModule, mkNugetDeps, emptyFile, lib, dotnet-sdk }:
let
  fsautocomplete = buildDotnetModule rec {
    pname = "pbm";
    version = "1.2.2";
    inherit dotnet-sdk;
    nugetDeps = mkNugetDeps {
      name = pname;
      nugetDeps = { fetchNuGet }: [
        (fetchNuGet { inherit pname version; sha256 = "sha256-DkbaUYnt6aJEFKp3wWceWxq87fzswjdMQvECCWiq+FU="; })
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
          <add key="nugetSource" value="${fsautocomplete.passthru.nuget-source}/lib" />
        </packageSources>
      </configuration>
      EOF
    '';

    executables = ".dotnet/tools/${pname}";
    buildPhase = ''
      #set env variable to install tool where fixupHook will be able to find it
      export DOTNET_CLI_HOME=$out/lib/${pname}
      dotnet tool install --configfile ./NuGet.config --global ${pname}

      cd $out
      #removing text files that contains nix store paths to temp nuget sources we made
      find . -name 'project.assets.json' -delete
      find . -name '.nupkg.metadata' -delete
    '';

    meta = with lib; {
      description = "CLI for managing Akka.NET applications and Akka.NET Clusters.";
      homepage = "https://cmd.petabridge.com/index.html";
      changelog = "https://cmd.petabridge.com/articles/RELEASE_NOTES.html";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ anpin ];
    };
  };
in
fsautocomplete
