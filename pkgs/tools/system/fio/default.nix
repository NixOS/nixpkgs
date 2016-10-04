{ stdenv, fetchFromGitHub, libaio, python, zlib }:

let
  version = "2.12";
  sha256 = "1m0fx0x1v2375vyxhd2i12b9w1qy4yh75f6qhwlcr78himcsmpp9";
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
