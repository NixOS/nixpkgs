{ lib
, dotnet_8
}:
dotnet_8.buildDotnetGlobalTool rec {
  pname = "csharp-ls";
  version = "0.11.0";

  nugetSha256 = "sha256-zB8uJqlf8kL8jh3WNsPQF7EJpONqi23co3O/iBzfEoU=";

  dotnet-runtime = dotnet_8.sdk;

  meta = with lib; {
    description = "Roslyn-based LSP language server for C#";
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    changelog = "https://github.com/razzmatazz/csharp-language-server/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
