{ stdenv, lib, fetchFromGitHub, cmake, qtbase, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "fwbuilder";
  version = "6.0.0-rc1";

  src = fetchFromGitHub {
    owner = "fwbuilder";
    repo = "fwbuilder";
    rev = "v${version}";
    hash = "sha256-j5HjGcIqq93Ca9OBqEgSotoSXyw+q6Fqxa3hKk1ctwQ=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "GUI Firewall Management Application";
    homepage    = "https://github.com/fwbuilder/fwbuilder";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = [ maintainers.elatov ];
  };
}
