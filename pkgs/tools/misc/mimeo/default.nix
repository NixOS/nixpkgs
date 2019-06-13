{ stdenv, fetchurl, desktop-file-utils, file, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "mimeo-${version}";
  version = "2019.3";

  src = fetchurl {
    url = "https://xyne.archlinux.ca/projects/mimeo/src/${name}.tar.xz";
    sha256 = "1ry9f08584vngznbja76z53as12q2i06ncfnf52dxyidfgw5mx65";
  };

  buildInputs = [ file desktop-file-utils ];

  propagatedBuildInputs = [ python3Packages.pyxdg ];

  preConfigure = ''
    substituteInPlace Mimeo.py \
      --replace "EXE_UPDATE_DESKTOP_DATABASE = 'update-desktop-database'" \
                "EXE_UPDATE_DESKTOP_DATABASE = '${desktop-file-utils}/bin/update-desktop-database'" \
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
