{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  xmlto,
  docbook_xml_dtd_44,
  docbook_xsl,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "vms-empire";
  version = "1.16";

  src = fetchurl {
    url = "http://www.catb.org/~esr/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-XETIbt/qVU+TpamPc2WQynqqUuZqkTUnItBprjg+gPk=";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [
    ncurses
    xmlto
    docbook_xml_dtd_44
    docbook_xsl
  ];

  postBuild = ''
    xmlto man vms-empire.xml
    xmlto html-nochunks vms-empire.xml
  '';

  installPhase = ''
    runHook preInstall
    install -D vms-empire -t ${placeholder "out"}/bin/
    install -D vms-empire.html -t ${placeholder "out"}/share/doc/${pname}/
    install -D vms-empire.desktop -t ${placeholder "out"}/share/applications/
    install -D vms-empire.png -t ${placeholder "out"}/share/icons/hicolor/48x48/apps/
    install -D vms-empire.xml -t ${placeholder "out"}/share/appdata/
    installManPage empire.6
    runHook postInstall
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "http://catb.org/~esr/vms-empire/";
    description = "The ancestor of all expand/explore/exploit/exterminate games";
    mainProgram = "vms-empire";
    longDescription = ''
      Empire is a simulation of a full-scale war between two emperors, the
      computer and you. Naturally, there is only room for one, so the object of
      the game is to destroy the other. The computer plays by the same rules
      that you do. This game was ancestral to all later
      expand/explore/exploit/exterminate games, including Civilization and
      Master of Orion.
    '';
    license = licenses.gpl2Only;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
