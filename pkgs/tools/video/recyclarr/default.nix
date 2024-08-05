{
  lib,
  openssl,
  writeText,
  git,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  recyclarr,
  testers,
}:
let
  nuget-config = writeText "nuget.config" ''
    <configuration>
      <packageSources>
        <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
      </packageSources>
    </configuration>
  '';
in
buildDotnetModule rec {
  pname = "recyclarr";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "recyclarr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KXFGT1fprRKN+V+3k0hpjjaI/xpw6UDAk+jj9zMek7k=";
  };

  projectFile = "Recyclarr.sln";
  nugetDeps = ./deps.nix;

  prePatch = ''
    substituteInPlace src/Recyclarr.Cli/Program.cs \
      --replace-fail '$"v{GitVersionInformation.SemVer} ({GitVersionInformation.FullBuildMetaData})"' '"${version}-nixpkgs"'

    substituteInPlace src/Recyclarr.Cli/Console/Setup/ProgramInformationDisplayTask.cs \
      --replace-fail 'GitVersionInformation.InformationalVersion' '"${version}-nixpkgs"'
  '';
  patches = [ ./001-Git-Version.patch ];

  dotnetRestoreFlags = [ "--configfile=${nuget-config}" ];

  doCheck = false;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnet-test-sdk = dotnetCorePackages.sdk_8_0;

  executables = [ "recyclarr" ];
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        git
        openssl
      ]
    }"
  ];

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion { package = recyclarr; };
  };

  meta = with lib; {
    description = "Automatically sync TRaSH guides to your Sonarr and Radarr instances";
    homepage = "https://recyclarr.dev/";
    changelog = "https://github.com/recyclarr/recyclarr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      josephst
      aldoborrero
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
