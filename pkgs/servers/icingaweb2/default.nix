{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper, php }:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2";
  version = "2.11.4";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icingaweb2";
    rev = "v${version}";
    hash = "sha256-UMC1puEM0PhIu+lJouOj81tI/E6fz1PzPN0FU7TNwTg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share
    cp -ra application bin etc library modules public $out
    cp -ra doc $out/share

    wrapProgram $out/bin/icingacli --prefix PATH : "${lib.makeBinPath [ php ]}"
  '';

  meta = with lib; {
    description = "Webinterface for Icinga 2";
    longDescription = ''
      A lightweight and extensible web interface to keep an eye on your environment.
      Analyse problems and act on them.
    '';
    homepage = "https://www.icinga.com/products/icinga-web-2/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ das_j ];
    mainProgram = "icingacli";
    platforms = platforms.all;
  };
}
