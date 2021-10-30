{ lib, stdenv, fetchFromGitHub, substituteAll, perl, file, ncurses, bash }:

stdenv.mkDerivation rec {
  pname = "lesspipe";
  version = "1.85";

  nativeBuildInputs = [ perl ];
  buildInputs = [ perl bash ];
  strictDeps = true;
  preConfigure = ''
    patchShebangs --build configure
  '';
  configureFlags = [ "--shell=${bash}/bin/bash" "--yes" ];
  configurePlatforms = [];
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "wofr06";
    repo = "lesspipe";
    rev = version;
    sha256 = "1v1jdkdq1phc93gdr6mjlk98gipxrkkq4bj8kks0kfdvjgdwkdaa";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      file = "${file}/bin/file";
      tput = "${ncurses}/bin/tput";
    })
    ./override-shell-detection.patch
  ];

  meta = with lib; {
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
