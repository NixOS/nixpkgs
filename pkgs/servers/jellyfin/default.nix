{ lib
, fetchFromGitHub
, fetchurl
, linkFarmFromDrvs
, makeWrapper
, nixosTests
, stdenv
, dotnetCorePackages
, dotnetPackages
, ffmpeg
, fontconfig
, freetype
, jellyfin-web
, sqlite
}:

let
  dotnet-sdk = dotnetCorePackages.sdk_5_0;
  dotnet-aspnetcore = dotnetCorePackages.aspnetcore_5_0;
  runtimeDeps = [
    ffmpeg
    fontconfig
    freetype
  ];

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
stdenv.mkDerivation rec {
  pname = "jellyfin";
  version = "10.7.7"; # ensure that jellyfin-web has matching version

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin";
    rev = "v${version}";
    sha256 = "mByGsz9+R8I5/f6hUoM9JK/MDcWIJ/Xt51Z/LRXeQQQ=";
  };

  nativeBuildInputs = [
    dotnet-sdk
    dotnetPackages.Nuget
    makeWrapper
  ];

  propagatedBuildInputs = [
    dotnet-aspnetcore
    sqlite
  ];

  nugetDeps = linkFarmFromDrvs "${pname}-nuget-deps" (import ./nuget-deps.nix {
    fetchNuGet = { name, version, sha256 }: fetchurl {
      name = "nuget-${name}-${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${name}/${version}";
      inherit sha256;
    };
  });

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)

    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_NOLOGO=1

    nuget sources Add -Name nixos -Source "$PWD/nixos"
    nuget init "$nugetDeps" "$PWD/nixos"

    # FIXME: https://github.com/NuGet/Home/issues/4413
    mkdir -p $HOME/.nuget/NuGet
    cp $HOME/.config/NuGet/NuGet.Config $HOME/.nuget/NuGet

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    dotnet publish Jellyfin.Server \
      --configuration Release \
      --runtime ${runtimeId} \
      --no-self-contained \
      --output $out/opt/jellyfin

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    makeWrapper ${dotnet-aspnetcore}/bin/dotnet $out/bin/jellyfin \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}" \
      --add-flags "$out/opt/jellyfin/jellyfin.dll" \
      --add-flags "--ffmpeg ${ffmpeg}/bin/ffmpeg" \
      --add-flags "--webdir ${jellyfin-web}/share/jellyfin-web"

    runHook postInstall
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
  };
}
