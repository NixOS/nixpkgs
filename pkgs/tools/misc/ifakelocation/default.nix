{ lib, buildDotnetModule, dotnetCorePackages, ffmpeg, fetchFromGitHub, stdenv }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch =
    with stdenv.hostPlatform;
    if isx86_32 then "x86"
    else if isx86_64 then "x64"
    else if isAarch32 then "arm"
    else if isAarch64 then "arm64"
    else "unknown";
  musl = lib.optionalString stdenv.hostPlatform.isMusl "musl-";
  # https://docs.microsoft.com/en-us/dotnet/core/rid-catalog#using-rids
  runtimeId = "${os}-${musl}${arch}";
in
buildDotnetModule rec {
  pname = "ifakelocation";
  version = "2022-06-15";

  src = fetchFromGitHub {
    owner = "master131";
    repo = "iFakeLocation";
    rev = "22f52165da346025a269a1cecd9c9b3c42502ba7";
    sha256 = "Amne4+tJy+rvmNYj1eiOX96kMbyVgdoLwfNYEiGz720=";
  };

  projectFile = "iFakeLocation/iFakeLocation.csproj";
  nugetDeps = ./deps.nix;

  # Make sure we're only building and publishing for .NET 6.0 - any less is unsupported on osx-arm64.
  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;
  dotnetBuildFlags = [ "--framework=net6.0" ];
  dotnetInstallFlags = [ "--framework=net6.0" ];

  dotnetFlags = [ "--runtime=${runtimeId}" ];

  executables = [ "iFakeLocation" ];

  meta = with lib; {
    description = "Simulates locations on iOS devices.";
    mainProgram = "iFakeLocation";
    homepage = "https://github.com/master131/iFakeLocation";
    license = licenses.mit;
    maintainers = with maintainers; [ epetousis ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
