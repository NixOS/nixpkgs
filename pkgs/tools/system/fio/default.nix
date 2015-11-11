{ stdenv, fetchFromGitHub, libaio, python, zlib }:

let version = "2.2.11"; in

stdenv.mkDerivation rec {
  name = "fio-${version}";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    rev = "fio-${version}";
    sha256 = "0g26xvbb60f96ks8q7jpap0xc2grb5j5w4m4glz910ndgf0s45wm";
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
    platforms = platforms.linux;
  };
}
