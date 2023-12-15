{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, marksman
, testers
}:

buildDotnetModule rec {
  pname = "marksman";
  version = "2023-11-20";

  src = fetchFromGitHub {
    owner = "artempyanykh";
    repo = "marksman";
    rev = version;
    sha256 = "sha256-sgAXGGlzQ6mrGG3cxQ8iCIzyc0TrlVFlCpl+nW46EPU=";
  };

  projectFile = "Marksman/Marksman.fsproj";
  dotnetBuildFlags = [ "-p:VersionString=${version}" ];

  doCheck = true;
  testProjectFile = "Tests/Tests.fsproj";

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  postInstall = ''
    install -m 644 -D -t "$out/share/doc/${pname}" LICENSE
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = marksman;
      command = "marksman --version";
    };
  };

  meta = with lib; {
    description = "Language Server for Markdown";
    longDescription = ''
      Marksman is a program that integrates with your editor
      to assist you in writing and maintaining your Markdown documents.
      Using LSP protocol it provides completion, goto definition,
      find references, rename refactoring, diagnostics, and more.
      In addition to regular Markdown, it also supports wiki-link-style
      references that enable Zettelkasten-like note taking.
    '';
    homepage = "https://github.com/artempyanykh/marksman";
    license = licenses.mit;
    maintainers = with maintainers; [ stasjok plusgut ];
    platforms = dotnet-sdk.meta.platforms;
  };
}
