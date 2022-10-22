{ lib, stdenv, fetchFromGitHub, substituteAll, makeWrapper, perl, procps, file, gnused, bash }:

stdenv.mkDerivation rec {
  pname = "lesspipe";
  version = "2.06";

  src = fetchFromGitHub {
    owner = "wofr06";
    repo = "lesspipe";
    rev = "v${version}";
    sha256 = "sha256-4hyDtr2/9lhAWuiLd7OQ/+rdg/u5f5JT4hba3wpxxzg=";
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
    for f in lesspipe.sh lesscomplete; do
      wrapProgram "$out/bin/$f" --prefix-each PATH : "${lib.makeBinPath [ file gnused procps ]}"
    done
  '';

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
