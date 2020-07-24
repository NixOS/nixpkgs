{ stdenv, fetchFromGitHub, substituteAll, perl, file, ncurses }:

stdenv.mkDerivation rec {
  pname = "lesspipe";
  version = "1.84";

  buildInputs = [ perl ];
  preConfigure = "patchShebangs .";

  src = fetchFromGitHub {
    owner = "wofr06";
    repo = "lesspipe";
    rev = version;
    sha256 = "124ffhzrikr88ab14rk6753n8adxijpmg7q3zx7nmqc52wpkfd8q";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      file = "${file}/bin/file";
      tput = "${ncurses}/bin/tput";
    })
  ];

  meta = with stdenv.lib; {
    description = "A preprocessor for less";
    longDescription = ''
      Usually lesspipe.sh is called as an input filter to less. With the help
      of that filter less will display the uncompressed contents of compressed
      (gzip, bzip2, compress, rar, 7-zip, lzip, xz or lzma) files. For files
      containing archives and directories, a table of contents will be
      displayed (e.g tar, ar, rar, jar, rpm and deb formats). Other supported
      formats include nroff, pdf, ps, dvi, shared library, MS word, OASIS
      (e.g. Openoffice), NetCDF, html, mp3, jpg, png, iso images, MacOSX bom,
      plist and archive formats, perl storable data and gpg encrypted files.
      This does require additional helper programs being installed.
    '';
    homepage = "https://github.com/wofr06/lesspipe";
    platforms = platforms.all;
    license = licenses.gpl2;
    maintainers = [ maintainers.martijnvermaat ];
  };
}
