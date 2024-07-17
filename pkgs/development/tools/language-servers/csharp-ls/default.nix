{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:
let
  inherit (dotnetCorePackages) sdk_8_0;
in

buildDotnetGlobalTool rec {
  pname = "csharp-ls";
  version = "0.13.0";

  nugetSha256 = "sha256-hhgMwDk3mT7E07REqZduTuEnS7D1tCgdxqN+MLNo9EI=";

  dotnet-sdk = sdk_8_0;
  dotnet-runtime = sdk_8_0;

  meta = with lib; {
    description = "Roslyn-based LSP language server for C#";
    mainProgram = "csharp-ls";
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    changelog = "https://github.com/razzmatazz/csharp-language-server/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
