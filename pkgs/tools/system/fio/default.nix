{ stdenv, fetchFromGitHub, libaio, python, zlib }:

let
  version = "3.6";
  sha256 = "1dilsn6r958skq1kpknm13fdzw7whb3bqa3wwnn2j9gba28599pq";
in

stdenv.mkDerivation rec {
  name = "fio-${version}";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    rev = "fio-${version}";
    inherit sha256;
  };

  buildInputs = [ python zlib ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) libaio;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "mandir = /usr/share/man" "mandir = \$(prefix)/man" \
      --replace "sharedir = /usr/share/fio" "sharedir = \$(prefix)/share/fio"
    substituteInPlace tools/plot/fio2gnuplot --replace /usr/share/fio $out/share/fio
  '';

  meta = with stdenv.lib; {
    homepage = "http://git.kernel.dk/?p=fio.git;a=summary;";
    description = "Flexible IO Tester - an IO benchmark tool";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
