{ stdenv, fetchFromGitHub, libaio, zlib }:

let version = "2.2.7"; in

stdenv.mkDerivation rec {
  name = "fio-${version}";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    rev = "fio-${version}";
    sha256 = "02k528n97xp1ly3d0mdn0lgwqlpn49b644696m75kcr0hn07382v";
  };

  buildInputs = [ libaio zlib ];

  enableParallelBuilding = true;

  configurePhase = ''
    substituteInPlace tools/plot/fio2gnuplot --replace /usr/share/fio $out/share/fio
    ./configure
  '';

  installPhase = ''
    make install prefix=$out
  '';

  meta = {
    homepage = "http://git.kernel.dk/?p=fio.git;a=summary";
    description = "Flexible IO Tester - an IO benchmark tool";
    license = stdenv.lib.licenses.gpl2;
  };
}
