{ lib
, buildDotnetGlobalTool
, dotnetCorePackages
}:
let
  inherit (dotnetCorePackages) sdk_7_0;
in

buildDotnetGlobalTool rec {
  pname = "csharp-ls";
  version = "0.8.0";

  nugetSha256 = "sha256-F3N6ESE/VmQA5sOMm3eqSkhSNVCCsnAXTCC+McsAnQw=";

  dotnet-sdk = sdk_7_0;
  dotnet-runtime = sdk_7_0;

  meta = with lib; {
    description = "Roslyn-based LSP language server for C#";
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    changelog = "https://github.com/razzmatazz/csharp-language-server/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
