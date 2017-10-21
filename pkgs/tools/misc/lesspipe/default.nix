{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "lesspipe-${version}";
  version = "1.82";

  buildInputs = [ perl ];
  preConfigure = "patchShebangs .";

  src = fetchFromGitHub {
    owner = "wofr06";
    repo = "lesspipe";
    rev = version;
    sha256 = "0vb7bpap8vy003ha10hc7hxl17y47sgdnrjpihgqxkn8k0bfqbbq";
  };

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
    homepage = https://github.com/wofr06/lesspipe;
    platforms = platforms.all;
    license = licenses.gpl2;
    maintainers = [ maintainers.martijnvermaat ];
  };
}
