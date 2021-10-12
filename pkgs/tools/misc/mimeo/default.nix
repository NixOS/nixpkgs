{ lib, fetchurl, desktop-file-utils, file, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "mimeo";
  version = "2021.2";

  src = fetchurl {
    url = "https://xyne.archlinux.ca/projects/mimeo/src/${pname}-${version}.tar.xz";
    sha256 = "113ip024ggajjdx0l406g6lwypdrddxz6k3640y6lzqjivcgybjf";
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

  meta = with lib; {
    description = "Open files by MIME-type or file name using regular expressions";
    homepage = "https://xyne.archlinux.ca/projects/mimeo/";
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
  };
}
