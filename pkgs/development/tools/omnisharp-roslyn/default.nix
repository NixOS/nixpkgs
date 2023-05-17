{ buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, lib
, stdenv
, runCommand
, expect
}:
let
  inherit (dotnetCorePackages) sdk_6_0 runtime_6_0;
in
let finalPackage = buildDotnetModule rec {
  pname = "omnisharp-roslyn";
  version = "1.39.6";

  src = fetchFromGitHub {
    owner = "OmniSharp";
    repo = pname;
    rev = "v${version}";
    sha256 = "6KCHZ5I5OkDaensqHO//owI/nrQkOoF60f/n3YV7jaE=";
  };

  projectFile = "src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj";
  nugetDeps = ./deps.nix;

  useAppHost = false;

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
  preFixup = ''
    # We create a wrapper that will run the OmniSharp dll using the `dotnet`
    # executable from PATH. Doing it this way allows it to run using newer SDK
    # versions than it was build with, which allows it to properly find those SDK
    # versions - OmniSharp only finds SDKs with the same version or newer as
    # itself. We still provide a fallback, in case no `dotnet` is provided in
    # PATH
    mkdir -p "$out/bin"

    cat << EOF > "$out/bin/OmniSharp"
    #!${stdenv.shell}
    export PATH="\''${PATH}:${sdk_6_0}/bin"
    dotnet "$out/lib/omnisharp-roslyn/OmniSharp.dll" "\$@"
    EOF

    chmod +x "$out/bin/OmniSharp"
  '';

  passthru.tests = let
    with-sdk = sdk: runCommand "with-${if sdk ? version then sdk.version else "no"}-sdk"
      { nativeBuildInputs = [ finalPackage sdk expect ]; meta.timeout = 60; } ''
      HOME=$TMPDIR
      expect <<"EOF"
        spawn OmniSharp
        expect_before timeout {
          send_error "timeout!\n"
          exit 1
        }
        expect ".NET Core SDK ${if sdk ? version then sdk.version else sdk_6_0.version}"
        expect "{\"Event\":\"started\","
        send \x03
        expect eof
        catch wait result
        exit [lindex $result 3]
      EOF
      touch $out
    '';
  in {
    # Make sure we can run OmniSharp with any supported SDK version, as well as without
    with-net6-sdk = with-sdk sdk_6_0;
    with-net7-sdk = with-sdk dotnetCorePackages.sdk_7_0;
    no-sdk = with-sdk null;
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
