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
  version = "10.5.5";

  # Impossible to build anything offline with dotnet
  src = fetchurl {
    url = "https://github.com/jellyfin/jellyfin/releases/download/v${version}/jellyfin_${version}_portable.tar.gz";
    sha256 = "1s3hva1j5w74qc9wyqnmr5clk4smzfi7wvx8qrzrwy81mx7r5w27";
  };

  buildInputs = [
    unzip
    makeWrapper
  ];

  propagatedBuildInputs = [
    dotnetCorePackages.aspnetcore_3_1
    sqlite
  ];

  preferLocalBuild = true;

  installPhase = ''
    install -dm 755 "$out/opt/jellyfin"
    cp -r * "$out/opt/jellyfin"
    makeWrapper "${dotnetCorePackages.aspnetcore_3_1}/bin/dotnet" $out/bin/jellyfin \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [
        sqlite fontconfig freetype stdenv.cc.cc.lib
      ]}:$out/opt/jellyfin/runtimes/${runtimeDir}/native/" \
      --add-flags "$out/opt/jellyfin/jellyfin.dll --ffmpeg ${ffmpeg}/bin/ffmpeg"
  '';

  passthru.tests = {
    smoke-test = nixosTests.jellyfin;
  };

  meta =  with stdenv.lib; {
    description = "The Free Software Media System";
    homepage = "https://jellyfin.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nyanloutre minijackson ];
  };
}
