{ stdenv, fetchurl, mono, curl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "jackett-${version}";
  version = "0.10.160";

  src = fetchurl {
    url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.Mono.tar.gz";
    sha256 = "1msy11s89r63vcan6d8mjn2jic1zwvl2j852mjj06bfb3yldx6vq";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${name}}
    cp -r * $out/share/${name}

    makeWrapper "${mono}/bin/mono" $out/bin/Jackett \
      --add-flags "$out/share/${name}/JackettConsole.exe" \
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
