{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "csharp-language-server";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "razzmatazz";
    repo = "csharp-language-server";
    rev = version;
    sha256 = "sha256-JIUYlvZ+9XnisRIgPm0lWsUvgnudUY19rL81iX0Utd4=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;

  selfContainedBuild = true;

  projectFile = "src/CSharpLanguageServer/CSharpLanguageServer.fsproj";
  nugetDeps = ./deps.nix;

  passthru.updateScript = ./update.sh;

  postFixup = ''
    ln -s $out/bin/CSharpLanguageServer $out/bin/csharp-ls
  '';

  meta = with lib; {
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    description = "Roslyn-based LSP language server for C#";
    changelog = "https://github.com/razzmatazz/csharp-language-server/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
    mainProgram = "csharp-ls";
  };
}
