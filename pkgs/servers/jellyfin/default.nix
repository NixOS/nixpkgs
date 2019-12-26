{ stdenv, lib, fetchurl, unzip, sqlite, makeWrapper, dotnet-sdk, ffmpeg,
  fontconfig, freetype }:

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
  version = "10.4.3";

  # Impossible to build anything offline with dotnet
  src = fetchurl {
    url = "https://github.com/jellyfin/jellyfin/releases/download/v${version}/jellyfin_${version}_portable.tar.gz";
    sha256 = "11scxcwf02h6gvll0jwwac1wcpwz8d2y16yc3da0hrhy34yhysbl";
  };

  buildInputs = [
    unzip
    makeWrapper
  ];

  propagatedBuildInputs = [
    dotnet-sdk
    sqlite
  ];

  preferLocalBuild = true;

  installPhase = ''
    install -dm 755 "$out/opt/jellyfin"
    cp -r * "$out/opt/jellyfin"

    makeWrapper "${dotnet-sdk}/bin/dotnet" $out/bin/jellyfin \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [
        sqlite fontconfig freetype stdenv.cc.cc.lib
      ]}:$out/opt/jellyfin/runtimes/${runtimeDir}/native/" \
      --add-flags "$out/opt/jellyfin/jellyfin.dll --ffmpeg ${ffmpeg}/bin/ffmpeg"
  '';

  meta =  with stdenv.lib; {
    description = "The Free Software Media System";
    homepage = https://jellyfin.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nyanloutre minijackson ];
  };
}
