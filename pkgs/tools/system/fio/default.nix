{ stdenv, fetchFromGitHub, libaio, python, zlib }:

let
  version = "2.17";
  sha256 = "17fygcy3flsp64mfmwpc66byy95cidby34s6grm3zgsjb7mcypr0";
in

stdenv.mkDerivation rec {
  name = "fio-${version}";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    rev = "fio-${version}";
    inherit sha256;
  };

  buildInputs = [ libaio python zlib ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace tools/plot/fio2gnuplot --replace /usr/share/fio $out/share/fio
  '';

  meta = with stdenv.lib; {
    homepage = "http://git.kernel.dk/?p=fio.git;a=summary";
    description = "Flexible IO Tester - an IO benchmark tool";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
