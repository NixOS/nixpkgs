{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "oppai-ng";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Francesco149";
    repo = pname;
    rev = version;
    sha256 = "sha256-fUtyQaHcNBmDs1BPbFGieKY/CFyETqBxYzzIXSERFJY=";
  };

  buildPhase = ''
    ./build
    ./libbuild
  '';

  installPhase = ''
    install -D oppai $out/bin/oppai
    install -D oppai.c $out/include/oppai.c
    install -D liboppai.so $out/lib/liboppai.so
  '';

  meta = with lib; {
    description = "Difficulty and pp calculator for osu!";
    homepage = "https://github.com/Francesco149/oppai-ng";
    license = licenses.unlicense;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
