{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnetCorePackages, patchelf, openssl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "radarr";
  version = "3.0.0.4204";

  src = fetchurl {
    url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.master.${version}.linux-core-x64.tar.gz";
    sha256 = "031k1awa9hzqmja3bwfakx4bs2rk2wvv0fs49c2il4ny44fyh0mp";
  };

  nativeBuildInputs = [
    makeWrapper
    patchelf
  ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnetCorePackages.netcore_3_1}/bin/dotnet" $out/bin/Radarr \
      --add-flags "$out/share/${pname}-${version}/Radarr.dll" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          curl sqlite libmediainfo mono openssl ]}
  '';

  postFixup = ''
    patchelf --set-rpath ${icu}/lib $out/share/${pname}-${version}/System.Globalization.Native.so
  '';

  passthru.tests = {
    smoke-test = nixosTests.radarr;
  };

  meta = with stdenv.lib; {
    description = "A Usenet/BitTorrent movie downloader";
    homepage = "https://radarr.video/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo purcell ];
    platforms = platforms.all;
  };
}
