{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, perl
, procps
, bash

# shell referenced dependencies
, resholve
, binutils-unwrapped
, file
, gnugrep
, coreutils
, gnused
, gnutar
, iconv
, ncurses
, squashfsTools
}:

stdenv.mkDerivation rec {
  pname = "lesspipe";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "wofr06";
    repo = "lesspipe";
    rev = "v${version}";
    hash = "sha256-SEFyiKxfKC2Rx5tQ2OK8zEiCBFex2kZUY/vnnDsdCoc=";
  };

  nativeBuildInputs = [ perl makeWrapper ];
  buildInputs = [ perl bash ];
  strictDeps = true;

  postPatch = ''
    patchShebangs --build configure
    substituteInPlace configure --replace '/etc/bash_completion.d' '/share/bash-completion/completions'
  '';

  configureFlags = [ "--shell=${bash}/bin/bash" "--prefix=/" ];
  configurePlatforms = [ ];

  dontBuild = true;

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    # resholve doesn't see strings in an array definition
    substituteInPlace $out/bin/lesspipe.sh --replace 'nodash strings' "nodash ${binutils-unwrapped}/bin/strings"

    ${resholve.phraseSolution "lesspipe.sh" {
      scripts = [ "bin/lesspipe.sh" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        file
        gnugrep
        gnused
        gnutar
        iconv
        procps
        ncurses
        squashfsTools
      ];
      keep = [ "$prog" "$c1" "$c2" "$c3" "$c4" "$c5" "$cmd" "$colorizer" "$HOME" ];
      fake = {
        # script guards usage behind has_cmd test function, it's safe to leave these external and optional
        external = [
          "7z" "7za" "7zr" "7zz" "antiword" "ar" "archive_color" "bat" "batcat" "broken_catppt" "brotli" "bsdtar" "bzip2"
          "cabextract" "catdoc" "ccze" "code2color" "column" "compress" "cpio" "csvlook" "csvtable"
          "djvutxt" "docx2txt" "dtc" "dvi2tty" "elinks" "excel2csv" "exiftool" "gpg" "groff" "gzip"
          "h5dump" "html2text" "id3v2" "identify" "in2csv" "isoinfo" "jq"
          "lessfilter" "libreoffice" "lynx" "lz4" "lzip" "lzma"
          "man" "mandoc" "matdump" "mdcat" "mediainfo" "ncdump" "odt2txt" "openssl"
          "pandoc" "pdfinfo" "pdftohtml" "pdftotext" "perldoc" "plistutil" "plutil"
          "pod2text" "pptx2md" "procyon" "ps2ascii" "pygmentize" "rar" "rpm" "rpm2cpio" "snap" "source-highlight"
          "sxw2txt" "tput" "unrar" "unrtf" "unsquashfs" "unzip" "vimcolor" "w3m" "wvText"
          "xls2csv" "xlscat" "xmq" "xz" "zlib-flate" "zstd"
        ] ++ lib.optional (stdenv.isDarwin || stdenv.isFreeBSD) [
          # resholve only identifies this on darwin/bsd
          # call site is guarded by || so it's safe to leave dynamic
          "locale"
        ];
        builtin = [ "setopt" ];
      };
      execer = [
        "cannot:${iconv}/bin/iconv"
      ];
    }}
    ${resholve.phraseSolution "lesscomplete" {
      scripts = [ "bin/lesscomplete" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        file
        gnugrep
        gnused
        gnutar
      ];
      keep = [ "$prog" "$c1" "$c2" "$c3" "$c4" "$c5" "$cmd" ];
      fake = {
        # script guards usage behind has_cmd test function, it's safe to leave these external and optional
        external = [
          "cpio" "isoinfo" "cabextract" "bsdtar" "rpm2cpio" "bsdtar" "unzip" "ar" "unrar" "rar" "7zr" "7za" "isoinfo"
          "gzip" "bzip2" "lzip" "lzma" "xz" "brotli" "compress" "zstd" "lz4"
        ];
        builtin = [ "setopt" ];
      };
    }}
  '';

  meta = with lib; {
    description = "Preprocessor for less";
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
    license = licenses.gpl2Only;
    maintainers = [ maintainers.martijnvermaat ];
  };
}
