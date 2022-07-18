{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, qtbase
, qttools
, radare2
, wrapQtAppsHook
, zip
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "iaito";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-qEJTsS669eEwo2iiuybN72O5oopCaGEkju8+ekjw2zk=";
  };

  nativeBuildInputs = [ pkg-config qttools wrapQtAppsHook zip ];
  buildInputs = [ radare2 qtbase ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "git submodule update --init" ""
  '';

  NIX_CFLAGS_COMPILE = [ "-I${radare2}/include/libr" "-I${radare2}/include/libr/sdb" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 build/iaito $out/bin/iaito
    install -Dm644 $src/src/org.radare.iaito.appdata.xml $out/share/metainfo/org.radare.iaito.appdata.xml
    install -Dm644 $src/src/org.radare.iaito.desktop $out/share/applications/org.radare.iaito.desktop
    install -Dm644 $src/src/img/iaito-o.svg $out/share/pixmaps/iaito-o.svg

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Official frontend of radare2";
    longDescription = ''
      The official graphical interface for radare2, a libre reverse engineering
      framework.
    '';
    homepage = "https://github.com/radareorg/iaito";
    changelog = "https://github.com/radareorg/iaito/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
  };
}
