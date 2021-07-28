{ mkDerivation
, lib
, fetchFromGitLab
, cmake
, ninja
, qtbase
, qtserialport
, qtermwidget
, libcprime
}:

mkDerivation rec {
  pname = "coreterminal";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YXs6VTem3AaK4n1DYwKP/jqNuf09Srn2THHyJJnArlc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtserialport
    qtermwidget
    libcprime
  ];

  meta = with lib; {
    description = "A terminal emulator from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreterminal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
