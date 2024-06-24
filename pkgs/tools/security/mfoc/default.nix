{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, libnfc }:

stdenv.mkDerivation rec {
  pname = "mfoc";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0hbg1fn4000qdg1cfc7y8l0vh1mxlxcz7gapkcq54xp2l6kk1z65";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/nfc-tools/mfoc/commit/f13efb0a6deb1d97ba945d555a6a5d6be89b593f.patch";
      sha256 = "109gqzp8rdsjvj0nra686vy0dpd2bl6q5v9m4v98cpxkbz496450";
    })
    (fetchpatch {
      url = "https://github.com/nfc-tools/mfoc/commit/00eae36f891bc4580103e3b54f0bb5228af2cdef.patch";
      sha256 = "1w56aj96g776f37j53jmf3hk21x4mqik3l2bmghrdp8drixc8bzk";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libnfc ];

  meta = with lib; {
    description = "Mifare Classic Offline Cracker";
    mainProgram = "mfoc";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/nfc-tools/mfoc";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
