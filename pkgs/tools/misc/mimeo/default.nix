{ stdenv, fetchurl, desktop_file_utils, file, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "mimeo-${version}";
  version = "2016.11";

  src = fetchurl {
    url = "http://xyne.archlinux.ca/projects/mimeo/src/${name}.tar.xz";
    sha256 = "1yygdxqnkh506fknxsp9xa3rnxn0901dzqc7c7qjjj80lk6xnfxb";
  };

  buildInputs = [ file desktop_file_utils ];

  propagatedBuildInputs = [ python3Packages.pyxdg ];

  preConfigure = ''
    substituteInPlace Mimeo.py \
      --replace "EXE_UPDATE_DESKTOP_DATABASE = 'update-desktop-database'" \
                "EXE_UPDATE_DESKTOP_DATABASE = '${desktop_file_utils}/bin/update-desktop-database'" \
      --replace "EXE_FILE = 'file'" \
                "EXE_FILE = '${file}/bin/file'"
  '';

  installPhase = "install -Dm755 Mimeo.py $out/bin/mimeo";

  meta = with stdenv.lib; {
    description = "Open files by MIME-type or file name using regular expressions";
    homepage = http://xyne.archlinux.ca/projects/mimeo/;
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
  };
}
