{stdenv, fetchFromGitHub, python2, which}:
stdenv.mkDerivation rec {
  name = "redo-apenwarr-${version}";

  version = "unstable-2019-06-21";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = "redo";
    rev = "8924fa35fa7363b531f8e6b48a1328d2407ad5cf";
    sha256 = "1dj20w29najqjyvk0jh5kqbcd10k32rad986q5mzv4v49qcwdc1q";
  };

  DESTDIR="";
  PREFIX = placeholder "out";

  patchPhase = ''
    patchShebangs .
  '';

  buildInputs = [ python2 which ];

  meta = with stdenv.lib; {
    description = "Apenwarr version of the redo build tool.";
    homepage = https://github.com/apenwarr/redo/;
    license = stdenv.lib.licenses.asl20;
    platforms = platforms.all;
    maintainers = with stdenv.lib.maintainers; [ andrewchambers ];
  };
}
