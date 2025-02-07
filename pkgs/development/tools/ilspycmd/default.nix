{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  powershell,
  autoSignDarwinBinariesHook,
  glibcLocales,
}:
buildDotnetModule (finalAttrs: rec {
  pname = "ilspycmd";
  version = "9.0-preview3";

  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "ILSpy";
    rev = "v${version}";
    hash = "sha256-7cPXFaEKr76GtqcNsKx7tstRUeTpSTF8ggxbyEnQa9M=";
  };

  nativeBuildInputs =
    [
      powershell
    ]
    ++ lib.optionals (stdenvNoCC.hostPlatform.isDarwin && stdenvNoCC.hostPlatform.isAarch64) [
      autoSignDarwinBinariesHook
    ];

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = lib.optionalString stdenvNoCC.hostPlatform.isLinux "${glibcLocales}/lib/locale/locale-archive";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  projectFile = "ICSharpCode.ILSpyCmd/ICSharpCode.ILSpyCmd.csproj";
  nugetDeps = ./deps.json;

  # see: https://github.com/tunnelvisionlabs/ReferenceAssemblyAnnotator/issues/94
  linkNugetPackages = true;

  meta = {
    description = "Tool for decompiling .NET assemblies and generating portable PDBs";
    mainProgram = "ilspycmd";
    homepage = "https://github.com/icsharpcode/ILSpy";
    changelog = "https://github.com/icsharpcode/ILSpy/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      mit
      # third party dependencies
      mspl
      asl20
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [ emilytrau ];
  };
})
