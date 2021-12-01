{ lib, stdenv, fetchFromGitHub, autoreconfHook, ncurses, pcre2 }:

stdenv.mkDerivation rec {
  pname = "fdupes";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "adrianlopezroche";
    repo  = "fdupes";
    rev   = "v${version}";
    sha256 = "1c5hv7vkfxsii1qafhsynzp9zkwim47xkpk27sy64qdsjnhysdak";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses pcre2 ];

  meta = with lib; {
    description = "Identifies duplicate files residing within specified directories";
    longDescription = ''
      fdupes searches the given path for duplicate files.
      Such files are found by comparing file sizes and MD5 signatures,
      followed by a byte-by-byte comparison.
    '';
    homepage = "https://github.com/adrianlopezroche/fdupes";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.maggesi ];
  };
}
