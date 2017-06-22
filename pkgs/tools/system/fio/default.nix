{ stdenv, fetchFromGitHub, libaio, python, zlib }:

let
  version = "2.20";
  sha256 = "06sn9ll75xbr2rr7zn8xzdy1v705kqfxv6q1zx6ysvxwri0sxrfx";
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
