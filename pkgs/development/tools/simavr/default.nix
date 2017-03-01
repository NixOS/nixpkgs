{ stdenv, fetchFromGitHub, avrgcclibc, libelf, which, git, pkgconfig, freeglut
, mesa }:

stdenv.mkDerivation rec {
  name = "simavr-${version}";
  version = "1.5";
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "buserror";
    repo = "simavr";
    rev = "e0d4de41a72520491a4076b3ed87beb997a395c0";
    sha256 = "0b2lh6l2niv80dmbm9xkamvnivkbmqw6v97sy29afalrwfxylxla";
  };

  buildFlags = "AVR_ROOT=${avrgcclibc}/avr SIMAVR_VERSION=${version}";
  installFlags = buildFlags + " DESTDIR=$(out)";

  postFixup = ''
    target="$out/bin/simavr"
    patchelf --set-rpath "$(patchelf --print-rpath "$target"):$out/lib" "$target"
  '';

  buildInputs = [ which git avrgcclibc libelf pkgconfig freeglut mesa ];

  meta = with stdenv.lib; {
    description = "A lean and mean Atmel AVR simulator";
    homepage    = https://github.com/buserror/simavr;
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ goodrone ];
  };

}

