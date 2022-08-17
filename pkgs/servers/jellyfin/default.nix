{ lib
, fetchFromGitHub
, fetchurl
, nixosTests
, stdenv
, dotnetCorePackages
, buildDotnetModule
, ffmpeg
, fontconfig
, freetype
, jellyfin-web
, sqlite
}:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch =
    with stdenv.hostPlatform;
    if isx86_32 then "x86"
    else if isx86_64 then "x64"
    else if isAarch32 then "arm"
    else if isAarch64 then "arm64"
    else lib.warn "Unsupported architecture, some image processing features might be unavailable" "unknown";
  musl = lib.optionalString stdenv.hostPlatform.isMusl
    (lib.warnIf (arch != "x64") "Some image processing features might be unavailable for non x86-64 with Musl"
      "musl-");
  # https://docs.microsoft.com/en-us/dotnet/core/rid-catalog#using-rids
  runtimeId = "${os}-${musl}${arch}";
in
buildDotnetModule rec {
  pname = "jellyfin";
  version = "10.8.3"; # ensure that jellyfin-web has matching version

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin";
    rev = "v${version}";
    sha256 = "QVpmHhVR4+UbVz5m92g5VcpcxVz1/9MNll2YN7ZnNHw=";
  };

  patches = [
    # when building some warnings are reported as error and fail the build.
    ./disable-warnings.patch
  ];

  propagatedBuildInputs = [
    sqlite
  ];

  projectFile = "Jellyfin.Server/Jellyfin.Server.csproj";
  executables = [ "jellyfin" ];
  nugetDeps = ./nuget-deps.nix;
  runtimeDeps = [
    ffmpeg
    fontconfig
    freetype
  ];
  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;
  dotnetFlags = [ "--runtime=${runtimeId}" ];
  dotnetBuildFlags = [ "--no-self-contained" ];

  preInstall = ''
    makeWrapperArgs+=(
      --add-flags "--ffmpeg ${ffmpeg}/bin/ffmpeg"
      --add-flags "--webdir ${jellyfin-web}/share/jellyfin-web"
    )
  '';

  passthru.tests = {
    smoke-test = nixosTests.jellyfin;
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "The Free Software Media System";
    homepage = "https://jellyfin.org/";
    # https://github.com/jellyfin/jellyfin/issues/610#issuecomment-537625510
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nyanloutre minijackson purcell jojosch ];
    platforms = dotnet-runtime.meta.platforms;
  };
}
