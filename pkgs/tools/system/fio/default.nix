{ stdenv, fetchFromGitHub, libaio, python, zlib }:

let version = "2.2.10"; in

stdenv.mkDerivation rec {
  name = "fio-${version}";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    rev = "fio-${version}";
    sha256 = "0hg72k8cifw6lc46kyiic7ai4gqn2819d6g998vmx01jnlcixp8q";
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
