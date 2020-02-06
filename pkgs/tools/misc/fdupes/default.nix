{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fdupes";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "adrianlopezroche";
    repo  = "fdupes";
    rev   = "v${version}";
    sha256 = "19b6vqblddaw8ccw4sn0qsqzbswlhrz8ia6n4m3hymvcxn8skpz9";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Identifies duplicate files residing within specified directories";
    longDescription = ''
      fdupes searches the given path for duplicate files.
      Such files are found by comparing file sizes and MD5 signatures,
      followed by a byte-by-byte comparison.
    '';
    homepage = https://github.com/adrianlopezroche/fdupes;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.maggesi ];
  };
}
