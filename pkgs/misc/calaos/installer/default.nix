{ mkDerivation, lib, stdenv, fetchFromGitHub, qmake, qttools, qtbase }:

mkDerivation rec {
  pname = "calaos_installer";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "calaos";
    repo = "calaos_installer";
    rev = "v${version}";
    sha256 = "hx7XVF2iueKFR67U0EvSK1vYZnJBnuOpUOkSjx7h1XY=";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase ];

  qmakeFlags = [ "REVISION=${version}" ];

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -a calaos_installer.app $out/Applications
  '' else ''
    mkdir -p $out/bin
    cp -a calaos_installer $out/bin
  '';

  meta = with lib; {
    description = "Calaos Installer, a tool to create calaos configuration";
    homepage = "https://www.calaos.fr/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ tiramiseb ];
  };
}
