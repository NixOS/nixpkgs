
with import <nixpkgs> {};
{
   Paket2Nix = callPackage ./Paket2Nix {
 
    Argu = callPackage ./Argu {};
    FAKE = callPackage ./FAKE {};
    FSharpCompilerService = callPackage ./FSharp.Compiler.Service {};
    FSharpCore = callPackage ./FSharp.Core {};
    FSharpFormatting = callPackage ./FSharp.Formatting {};
    FSharpVSPowerToolsCore = callPackage ./FSharpVSPowerTools.Core {};
    MicrosoftBcl = callPackage ./Microsoft.Bcl {};
    MicrosoftBclBuild = callPackage ./Microsoft.Bcl.Build {};
    MicrosoftNetHttp = callPackage ./Microsoft.Net.Http {};
    NewtonsoftJson = callPackage ./Newtonsoft.Json {};
    NUnit = callPackage ./NUnit {};
    NUnitRunners = callPackage ./NUnit.Runners {};
    Octokit = callPackage ./Octokit {};
    PaketCore = callPackage ./Paket.Core {};
    SourceLinkFake = callPackage ./SourceLink.Fake {}; 
};
}