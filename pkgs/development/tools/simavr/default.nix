{ stdenv, fetchFromGitHub, avrgcclibc, libelf, which, git, pkgconfig, freeglut
, mesa }:

stdenv.mkDerivation rec {
  name = "simavr-${version}";
  version = "1.3";
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "buserror";
    repo = "simavr";
    rev = "51d5fa69f9bc3d62941827faec02f8fbc7e187ab";
    sha256 = "0k8xwzw9i6xsmf98q43fxhphq0wvflvmzqma1n4jd1ym9wi48lfx";
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

