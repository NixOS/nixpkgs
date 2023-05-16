{ lib, stdenv, fetchFromGitHub, makeWrapper
, libaio, python3, zlib
, withGnuplot ? false, gnuplot ? null }:

stdenv.mkDerivation rec {
  pname = "fio";
<<<<<<< HEAD
  version = "3.35";
=======
  version = "3.34";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "axboe";
    repo   = "fio";
    rev    = "fio-${version}";
<<<<<<< HEAD
    sha256 = "sha256-8LMpgayxBebHb0MXYmjlqqtndSiL42/yEQpgamxt9kI=";
=======
    sha256 = "sha256-+csIerzwYOmXfmykYI0DHzbJf4iUCkEy1f7SFmAiuv4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ python3 zlib ]
    ++ lib.optional (!stdenv.isDarwin) libaio;

<<<<<<< HEAD
  # ./configure does not support autoconf-style --build=/--host=.
  # We use $CC instead.
  configurePlatforms = [ ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ makeWrapper python3.pkgs.wrapPython ];

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "mandir = /usr/share/man" "mandir = \$(prefix)/man" \
      --replace "sharedir = /usr/share/fio" "sharedir = \$(prefix)/share/fio"
    substituteInPlace tools/plot/fio2gnuplot --replace /usr/share/fio $out/share/fio
  '';

  pythonPath = [ python3.pkgs.six ];

  makeWrapperArgs = lib.optionals withGnuplot [
    "--prefix PATH : ${lib.makeBinPath [ gnuplot ]}"
  ];

  postInstall = ''
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
  '';

  meta = with lib; {
    description = "Flexible IO Tester - an IO benchmark tool";
    homepage = "https://git.kernel.dk/cgit/fio/";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
