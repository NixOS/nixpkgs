{ stdenv, lib, fetchurl, unzip, sqlite, makeWrapper, dotnetCorePackages, ffmpeg,
  fontconfig, freetype, nixosTests }:

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
    (if (arch != "x64")
      then lib.warn "Some image processing features might be unavailable for non x86-64 with Musl" "musl-"
      else "musl-");
  runtimeDir = "${os}-${musl}${arch}";

in stdenv.mkDerivation rec {
  pname = "jellyfin";
  version = "10.7.2";

  # Impossible to build anything offline with dotnet
  src = fetchurl {
    url = "https://repo.jellyfin.org/releases/server/portable/versions/stable/combined/${version}/jellyfin_${version}.tar.gz";
    sha256 = "sha256-l2tQmKez06cekq/QLper+OrcSU/0lWpZ85xY2wZcK1s=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  propagatedBuildInputs = [
    dotnetCorePackages.aspnetcore_5_0
    sqlite
  ];

  preferLocalBuild = true;

  installPhase = ''
    runHook preInstall
    install -dm 755 "$out/opt/jellyfin"
    cp -r * "$out/opt/jellyfin"
    makeWrapper "${dotnetCorePackages.aspnetcore_5_0}/bin/dotnet" $out/bin/jellyfin \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        sqlite fontconfig freetype stdenv.cc.cc.lib
      ]}:$out/opt/jellyfin/runtimes/${runtimeDir}/native/" \
      --add-flags "$out/opt/jellyfin/jellyfin.dll --ffmpeg ${ffmpeg}/bin/ffmpeg"
    runHook postInstall
  '';

  passthru.tests = {
    smoke-test = nixosTests.jellyfin;
  };

  meta =  with lib; {
    description = "The Free Software Media System";
    homepage = "https://jellyfin.org/";
    # https://github.com/jellyfin/jellyfin/issues/610#issuecomment-537625510
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nyanloutre minijackson purcell ];
  };
}
