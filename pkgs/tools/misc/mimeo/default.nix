{ lib, fetchurl, desktop-file-utils, file, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "mimeo";
  version = "2021.11";

  src = fetchurl {
    url = "https://xyne.dev/projects/mimeo/src/${pname}-${version}.tar.xz";
    sha256 = "1fi8svn4hg2hmvv28j026sks1hc0v8wh974g7ixcwfcg2xda6c4p";
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

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/mimeo --help > /dev/null
  '';

  meta = with lib; {
    description = "Open files by MIME-type or file name using regular expressions";
    homepage = "https://xyne.dev/projects/mimeo/";
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
  };
}
