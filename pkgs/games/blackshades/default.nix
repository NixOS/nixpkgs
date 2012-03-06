{stdenv, fetchsvn, SDL, mesa, openal, libvorbis, freealut, SDL_image}:

stdenv.mkDerivation rec {
  name = "blackshades-svn-110";
  src = fetchsvn {
    url = svn://svn.icculus.org/blackshades/trunk;
    rev = 110;
    sha256 = "0kbrh1dympk8scjxr6av24qs2bffz44l8qmw2m5gyqf4g3rxf6ra";
  };

  NIX_LDFLAGS = "-lSDL_image";

  buildInputs = [ SDL SDL_image mesa openal libvorbis freealut ];

  patchPhase = ''
    sed -i -e s,Data/,$out/opt/$name/Data/,g \
      -e s,Data:,$out/opt/$name/Data/,g \
      Source/*.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/opt/$name
    cp objs/blackshades $out/bin
    cp -R Data IF* Readme $out/opt/$name/
  '';

  meta = {
    homepage = http://icculus.org/blackshades/;
    description = "Protect the VIP";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
