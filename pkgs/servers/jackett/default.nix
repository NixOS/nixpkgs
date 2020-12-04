{ lib, stdenv, fetchurl, mono, makeWrapper, curl, icu60, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.16.2291";

  src = fetchurl {
    url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.Mono.tar.gz";
    sha256 = "1ybjssrj73qf34v66cv32gnlpvppp8kg2bwdv0r7qdy2vj5dx14a";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}

    makeWrapper "${mono}/bin/mono" $out/bin/Jackett \
      --add-flags "$out/share/${pname}-${version}/JackettConsole.exe" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ curl icu60 openssl zlib ]}
  '';

  meta = with stdenv.lib; {
    description = "API Support for your favorite torrent trackers";
    homepage = "https://github.com/Jackett/Jackett/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo nyanloutre purcell ];
    platforms = platforms.all;
  };
}
