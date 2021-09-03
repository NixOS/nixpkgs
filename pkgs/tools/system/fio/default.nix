{ lib, stdenv, fetchFromGitHub, makeWrapper
, libaio, python3, zlib
, withGnuplot ? false, gnuplot ? null }:

stdenv.mkDerivation rec {
  pname = "fio";
  version = "3.27";

  src = fetchFromGitHub {
    owner  = "axboe";
    repo   = "fio";
    rev    = "fio-${version}";
    sha256 = "sha256-/VzqmDbCTOOwFBMDj9nYuAW7ZJNM8B2LQ3QxReWG+iw=";
  };

  buildInputs = [ python3 zlib ]
    ++ lib.optional (!stdenv.isDarwin) libaio;

  nativeBuildInputs = [ makeWrapper ];

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "mandir = /usr/share/man" "mandir = \$(prefix)/man" \
      --replace "sharedir = /usr/share/fio" "sharedir = \$(prefix)/share/fio"
    substituteInPlace tools/plot/fio2gnuplot --replace /usr/share/fio $out/share/fio
  '';

  postInstall = lib.optionalString withGnuplot ''
    wrapProgram $out/bin/fio2gnuplot \
      --prefix PATH : ${lib.makeBinPath [ gnuplot ]}
  '';

  meta = with lib; {
    description = "Flexible IO Tester - an IO benchmark tool";
    homepage = "https://git.kernel.dk/cgit/fio/";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
