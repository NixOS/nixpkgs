{ stdenv, fetchFromGitHub, qmake, qttools, qtbase }:

stdenv.mkDerivation rec {
  name = "calaos_installer-3.1";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "calaos";
    repo = "calaos_installer";
    rev = "v${version}";
    sha256 = "0g8igj5sax5vjqzrpbil7i6329708lqqwvg5mwiqd0zzzha9sawd";
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

  meta = with stdenv.lib; {
    description = "Calaos Installer, a tool to create calaos configuration";
    homepage = https://www.calaos.fr/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ tiramiseb ];
  };
}
