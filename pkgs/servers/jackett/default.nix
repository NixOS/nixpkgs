{ stdenv, fetchurl, mono, curl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.11.559";

  src = fetchurl {
    url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.Mono.tar.gz";
    sha256 = "1ds263q92igvgn0dirl506cmrzy374msaxl1x13gax0i0ggf09mq";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}

    makeWrapper "${mono}/bin/mono" $out/bin/Jackett \
      --add-flags "$out/share/${pname}-${version}/JackettConsole.exe" \
      --prefix LD_LIBRARY_PATH ':' "${curl.out}/lib"
  '';

  meta = with stdenv.lib; {
    description = "API Support for your favorite torrent trackers.";
    homepage = https://github.com/Jackett/Jackett/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.all;
  };
}
