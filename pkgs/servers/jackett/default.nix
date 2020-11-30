{ lib, stdenv, fetchurl, mono, makeWrapper, curl, icu60, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.16.2269";

  src = fetchurl {
    url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.Mono.tar.gz";
    sha256 = "0bzyp2jjbfjh1xr2ga8vl6vyjhwks824sa8r1g5iydn9y36am7pf";
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
