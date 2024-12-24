{ lib
, stdenv
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, powershell
, autoSignDarwinBinariesHook
, glibcLocales
}:
buildDotnetModule rec {
  pname = "ilspycmd";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "ILSpy";
    rev = "v${version}";
    hash = "sha256-ERBYXgpBRXISfqBSBEydEQuD/5T1dvJ+wNg2U5pKip4=";
  };

  nativeBuildInputs = [
    powershell
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [ autoSignDarwinBinariesHook ];

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = lib.optionalString stdenv.hostPlatform.isLinux "${glibcLocales}/lib/locale/locale-archive";

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  projectFile = "ICSharpCode.ILSpyCmd/ICSharpCode.ILSpyCmd.csproj";
  nugetDeps = ./deps.json;

  # see: https://github.com/tunnelvisionlabs/ReferenceAssemblyAnnotator/issues/94
  linkNugetPackages = true;

  meta = with lib; {
    description = "Tool for decompiling .NET assemblies and generating portable PDBs";
    mainProgram = "ilspycmd";
    homepage = "https://github.com/icsharpcode/ILSpy";
    changelog = "https://github.com/icsharpcode/ILSpy/releases/tag/${src.rev}";
    license = with licenses; [
      mit
      # third party dependencies
      mspl
      asl20
    ];
    sourceProvenance = with sourceTypes; [ fromSource binaryBytecode ];
    maintainers = with maintainers; [ emilytrau ];
  };
}
