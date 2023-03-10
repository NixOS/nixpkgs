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

buildDotnetModule rec {
  pname = "jellyfin";
  version = "10.8.9"; # ensure that jellyfin-web has matching version

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin";
    rev = "v${version}";
    sha256 = "kvtC9qtVuewR9W6sq963/tNgZbWSpygpBqcXnHuvX0Q=";
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
