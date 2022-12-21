{ buildDotnetModule, mkNugetDeps, emptyFile, lib, dotnet-sdk }:
let
  fsautocomplete = buildDotnetModule rec {
    pname = "fsautocomplete";
    version = "0.58.2";
    inherit dotnet-sdk;
    nugetDeps = mkNugetDeps {
      name = pname;
      nugetDeps = { fetchNuGet }: [
        (fetchNuGet { inherit pname version; sha256 = "sha256-xZFTxdD4ma5IlPZNqOSwJv/1ixicm21FY+WVS574QiI="; })
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
      description = "The FsAutoComplete project (FSAC) provides a backend service for rich editing or intellisense features for editors.";
      homepage = "https://github.com/fsharp/FsAutoComplete";
      changelog = "https://github.com/fsharp/FsAutoComplete/releases/tag/v${version}";
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = with maintainers; [ gbtb ];
    };
  };
in
fsautocomplete
