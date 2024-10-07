{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, stdenv
}:

buildDotnetModule rec {
  pname = "certdump";
  version = "unstable-2023-07-12";

  src = fetchFromGitHub {
    owner = "secana";
    repo = "CertDump";
    rev = "1300005115786b3c214d73fa506de2de06a62cbb";
    sha256 = "sha256-VqKOoW4fAXr0MtY5rgWvRqay1dazF+ZpzJUHkDeXpPs=";
  };

  projectFile = [ "CertDump.sln" ];
  nugetDeps = ./deps.nix;

  selfContainedBuild = true;
  executables = [ "CertDump" ];
  xBuildFiles = [ "CertDump/CertDump.csproj" ];

  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0;
  dotnet-sdk = dotnetCorePackages.sdk_7_0;

  dotnetFlags = [
    "-property:ImportByWildcardBeforeSolution=false"
    "-property:GenerateAssemblyInfo=false"
  ];

  meta = with lib; {
    description = "Dump certificates from PE files in different formats";
    mainProgram = "CertDump";
    homepage = "https://github.com/secana/CertDump";
    longDescription = ''
      Cross-Platform tool to dump the signing certificate from a Portable Executable (PE) file.
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.baloo ];
    # net5 has no osx-arm64 target available
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
}
