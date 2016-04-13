{stdenv, fetchurl, scons, zlib, SDL, lua5_1, pkgconfig}:

stdenv.mkDerivation {
  name = "fceux-2.2.2";

  src = fetchurl {
    url = mirror://sourceforge/fceultra/Source%20Code/2.2.2%20src/fceux-2.2.2.src.tar.gz;
    sha256 = "1qg5bygla8ka30b7wqvq6dv84xc7pq0jspffh2jz75d1njyi2kc0";
  };

  buildInputs = [
    scons zlib SDL lua5_1 pkgconfig
  ];

  phases = "unpackPhase buildPhase";

  # sed allows scons to find libraries in nix.
  # mkdir is a hack to make scons succeed.  It still doesn't
  # actually put the files in there due to a bug in the SConstruct file.
  # OPENGL doesn't work because fceux dlopens the library.
  buildPhase = ''
    sed -e 's/env *= *Environment *.*/&; env['"'"'ENV'"'"']=os.environ;/' -i SConstruct
    export CC="gcc"
    export CXX="g++"
    mkdir -p "$out" "$out/share/applications" "$out/share/pixmaps"
    scons --prefix="$out" OPENGL=false GTK=false CREATE_AVI=false LOGO=false install
  '';

  meta = {
    description = "A Nintendo Entertainment System (NES) Emulator";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://www.fceux.com/;
  };
}
