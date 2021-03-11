{ lib, stdenv, fetchurl, dotnetCorePackages, makeWrapper, curl, icu60, openssl, zlib, nixosTests }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.17.671";

  src = fetchurl {
    url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxAMDx64.tar.gz";
    sha256 = "19yhfyznkqdwj408hz5481lvaz7ri6sib7bsmh0lxg0mvx35rq9r";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}

    makeWrapper "${dotnetCorePackages.netcore_3_1}/bin/dotnet" $out/bin/Jackett \
      --add-flags "$out/share/${pname}-${version}/jackett.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          curl icu60 openssl zlib ]}
  '';

  passthru.tests = {
    smoke-test = nixosTests.jackett;
  };

  meta = with lib; {
    description = "API Support for your favorite torrent trackers";
    homepage = "https://github.com/Jackett/Jackett/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ edwtjo nyanloutre purcell ];
    platforms = platforms.all;
  };
}
