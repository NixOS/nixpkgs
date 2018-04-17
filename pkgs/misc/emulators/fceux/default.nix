{stdenv, fetchurl, scons, zlib, SDL, lua5_1, pkgconfig}:

stdenv.mkDerivation {
  name = "fceux-2.2.3";

  src = fetchurl {
    url = mirror://sourceforge/fceultra/Source%20Code/2.2.3%20src/fceux-2.2.3.src.tar.gz;
    sha256 = "0gl2i3qdmcm7v9m5kpfz98w05d8m33990jiwka043ya7lflxvrjb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    scons zlib SDL lua5_1
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
    platforms = stdenv.lib.platforms.linux;
  };
}
