{stdenv, fetchFromGitHub, cmake, fmod, mesa, SDL2}:

stdenv.mkDerivation {
  name = "gzdoom-2015-05-07";
  src = fetchFromGitHub{
    owner = "coelckers";
    repo = "gzdoom";
    rev = "a59824cd8897dea5dd452c31be1328415478f990";
    sha256 = "1lg9dk5prn2bjmyznq941a862alljvfgbb42whbpg0vw9vhpikak";
  };

  buildInputs = [ cmake fmod mesa SDL2 ];

  cmakeFlags = [ "-DFMOD_LIBRARY=${fmod}/lib/libfmodex.so" ];

  preConfigure=''
    sed s@gzdoom.pk3@$out/share/gzdoom.pk3@ -i src/version.h
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp gzdoom $out/bin
    mkdir -p $out/share
    cp gzdoom.pk3 $out/share
  '';

  meta = {
    homepage = https://github.com/coelckers/gzdoom;
    description = "A Doom source port based on ZDoom. It features an OpenGL renderer and lots of new features";
    maintainers = [ stdenv.lib.maintainers.lassulus ];
  };
}

