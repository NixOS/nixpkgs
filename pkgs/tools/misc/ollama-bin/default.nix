{ stdenv
, pkgs
, lib
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  name = "ollama-bin";
  version = "0.1.8";

  src = fetchurl {
    url = "https://github.com/jmorganca/ollama/releases/download/${version}/ollama-linux-amd64";
    hash = "sha256-WxRimPMHV2qbePUu9EVniApXy2NrLK97LsXO+Burdkk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 -D $src $out/bin/ollama
  '';

  meta = with lib; {
    homepage = "https://ollama.ai";
    description = "Get up and running with large language models, locally";
    platforms = platforms.linux;
  };
}

