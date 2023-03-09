{ buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, icu
, lib
, patchelf
, stdenv
, runCommand
, expect
}:
let
  inherit (dotnetCorePackages) sdk_6_0 runtime_6_0;
in
let finalPackage = buildDotnetModule rec {
  pname = "omnisharp-roslyn";
  version = "1.39.4";

  src = fetchFromGitHub {
    owner = "OmniSharp";
    repo = pname;
    rev = "v${version}";
    sha256 = "rX0FeURw6WMbcJOomqHFcZ9tpKO1td60/HbbVClV324=";
  };

  projectFile = "src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj";
  nugetDeps = ./deps.nix;

  nativeBuildInputs = [
    patchelf
  ];

  dotnetInstallFlags = [ "--framework net6.0" ];
  dotnetBuildFlags = [ "--framework net6.0" "--no-self-contained" ];
  dotnetFlags = [
    # These flags are set by the cake build.
    "-property:PackageVersion=${version}"
    "-property:AssemblyVersion=${version}.0"
    "-property:FileVersion=${version}.0"
    "-property:InformationalVersion=${version}"
    "-property:RuntimeFrameworkVersion=${runtime_6_0.version}"
    "-property:RollForward=LatestMajor"
  ];

  postPatch = ''
    # Relax the version requirement
    substituteInPlace global.json \
      --replace '7.0.100-rc.1.22431.12' '${sdk_6_0.version}'
    # Patch the project files so we can compile them properly
    for project in src/OmniSharp.Http.Driver/OmniSharp.Http.Driver.csproj src/OmniSharp.LanguageServerProtocol/OmniSharp.LanguageServerProtocol.csproj src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj; do
      substituteInPlace $project \
        --replace '<RuntimeIdentifiers>win7-x64;win7-x86;win10-arm64</RuntimeIdentifiers>' '<RuntimeIdentifiers>linux-x64;linux-arm64;osx-x64;osx-arm64</RuntimeIdentifiers>'
    done
  '';

  dontDotnetFixup = true; # we'll fix it ourselves
  postFixup = lib.optionalString stdenv.isLinux ''
    # Emulate what .NET 7 does to its binaries while a fix doesn't land in buildDotnetModule
    patchelf --set-interpreter $(patchelf --print-interpreter ${sdk_6_0}/dotnet) \
      --set-rpath $(patchelf --print-rpath ${sdk_6_0}/dotnet) \
      $out/lib/omnisharp-roslyn/OmniSharp

  '' + ''
    # Now create a wrapper without DOTNET_ROOT
    # we explicitly don't set DOTNET_ROOT as it should get the one from PATH
    # as you can use any .NET SDK higher than 6 to run OmniSharp and you most
    # likely will NOT want the .NET 6 runtime running it (as it'll use that to
    # detect the SDKs for its own use, so it's better to let it find it in PATH).
    makeWrapper $out/lib/omnisharp-roslyn/OmniSharp $out/bin/OmniSharp \
      --prefix LD_LIBRARY_PATH : ${sdk_6_0.icu}/lib \
      --set-default DOTNET_ROOT ${sdk_6_0}
  '';

  passthru.tests = {
    no-sdk = runCommand "no-sdk" { nativeBuildInputs = [ finalPackage expect ]; meta.timeout = 60; } ''
      HOME=$TMPDIR
      expect <<"EOF"
        spawn OmniSharp
        expect_before timeout {
          send_error "timeout!\n"
          exit 1
        }
        expect "\"ERROR\",\"Name\":\"OmniSharp.MSBuild.Discovery.Providers.SdkInstanceProvider\""
        expect eof
        catch wait result
        if { [lindex $result 3] == 0 } {
          exit 1
        }
      EOF
      touch $out
    '';

    with-sdk = runCommand "with-sdk" { nativeBuildInputs = [ finalPackage sdk_6_0 expect ]; meta.timeout = 60; } ''
      HOME=$TMPDIR
      expect <<"EOF"
        spawn OmniSharp
        expect_before timeout {
          send_error "timeout!\n"
          exit 1
        }
        expect "{\"Event\":\"started\","
        send \x03
        expect eof
        catch wait result
        exit [lindex $result 3]
      EOF
      touch $out
    '';
  };

  meta = with lib; {
    description = "OmniSharp based on roslyn workspaces";
    homepage = "https://github.com/OmniSharp/omnisharp-roslyn";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode # dependencies
    ];
    license = licenses.mit;
    maintainers = with maintainers; [ tesq0 ericdallo corngood mdarocha ];
    mainProgram = "OmniSharp";
  };
}; in finalPackage
