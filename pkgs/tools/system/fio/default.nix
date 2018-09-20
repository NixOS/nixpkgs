{ stdenv, fetchFromGitHub, makeWrapper
, libaio, python, zlib
, withGnuplot ? false, gnuplot ? null }:

stdenv.mkDerivation rec {
  name = "fio-${version}";
  version = "3.10";

  src = fetchFromGitHub {
    owner  = "axboe";
    repo   = "fio";
    rev    = "fio-${version}";
    sha256 = "0cg6knaja32g46j1vlf0qw4q8yng7hrnnvh6b768pbjdxpn3wvi0";
  };

  buildInputs = [ python zlib ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) libaio;

  nativeBuildInputs = [ makeWrapper ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "mandir = /usr/share/man" "mandir = \$(prefix)/man" \
      --replace "sharedir = /usr/share/fio" "sharedir = \$(prefix)/share/fio"
    substituteInPlace tools/plot/fio2gnuplot --replace /usr/share/fio $out/share/fio
  '';

  postInstall = stdenv.lib.optionalString withGnuplot ''
    wrapProgram $out/bin/fio2gnuplot \
      --prefix PATH : ${stdenv.lib.makeBinPath [ gnuplot ]}
  '';

  meta = with stdenv.lib; {
    description = "Flexible IO Tester - an IO benchmark tool";
    homepage = "http://git.kernel.dk/?p=fio.git;a=summary;";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
