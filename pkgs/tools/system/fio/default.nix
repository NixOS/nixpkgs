{ stdenv, fetchFromGitHub, libaio, python, zlib }:

let
  version = "3.1";
  sha256 = "09rsfhzpi089cwpg07c8kgvs4d2n77a7mn1vj8iwjjzacs3fbllx";
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
    homepage = "http://git.kernel.dk/?p=fio.git;a=summary;";
    description = "Flexible IO Tester - an IO benchmark tool";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
