{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "oppai-ng";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "Francesco149";
    repo = pname;
    rev = version;
    sha256 = "1wrnpnx1yl0pdzmla4knlpcwy7baamy2wpdypnbdqxrn0zkw7kzk";
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

  meta = with stdenv.lib; {
    description = "Difficulty and pp calculator for osu!";
    homepage = "https://github.com/Francesco149/oppai-ng";
    license = licenses.unlicense;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
