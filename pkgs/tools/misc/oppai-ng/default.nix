{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "oppai-ng";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "Francesco149";
    repo = pname;
    rev = version;
    sha256 = "0ymprwyv92pr58851wzryymhfznnpwcbg4m1yri0c9cyzvabwmfk";
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
