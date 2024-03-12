{ lib
, buildDotnetGlobalTool
, dotnetCorePackages
}:
let
  inherit (dotnetCorePackages) sdk_8_0;
in

buildDotnetGlobalTool rec {
  pname = "csharp-ls";
  version = "0.11.0";

  nugetSha256 = "sha256-zB8uJqlf8kL8jh3WNsPQF7EJpONqi23co3O/iBzfEoU=";

  dotnet-sdk = sdk_8_0;
  dotnet-runtime = sdk_8_0;

  meta = with lib; {
    description = "Roslyn-based LSP language server for C#";
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    changelog = "https://github.com/razzmatazz/csharp-language-server/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
