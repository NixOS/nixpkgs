{ buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, lib
}:

buildDotnetModule rec {
  pname = "cyclonedx";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-cli";
    rev = "tags/v${version}";
    hash = "sha256-TkX060Dx//b0yCXS+MQPrAD2iuOVqEAEdJdbCBqQL1s=";
  };

  projectFile = "cyclonedx-cli.sln";
  nugetDeps = ./deps.nix; # File generated with `./update.sh`

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;
  dotnetFlags = [ "-p:PublishTrimmed=false" ];

  executables = [ "cyclonedx" ];

  meta = with lib; {
    description = "CycloneDX CLI tool for SBOM analysis, merging, diffs and format conversions.";
    longDescription = ''
      The CycloneDX CLI tool currently supports BOM analysis, modification, diffing, merging, format conversion, signing and verification.

      Conversion is supported between CycloneDX XML, JSON, Protobuf, CSV, and SPDX JSON v2.2.
    '';
    homepage = "https://cyclonedx.org/";
    license = licenses.asl20;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.all;
  };
}
