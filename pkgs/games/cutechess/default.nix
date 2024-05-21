{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, qtbase
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cutechess";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "cutechess";
    repo = "cutechess";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P44Twbw2MGz+oTzPwMFCe73zPxAex6uYjSTtaUypfHw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
  ];

  postInstall = ''
    install -Dm555 cutechess{,-cli} -t $out/bin/
    install -Dm444 libcutechess.a -t $out/lib/
    install -Dm444 $src/docs/cutechess-cli.6 -t $out/share/man/man6/
    install -Dm444 $src/docs/cutechess-engines.json.5 -t $out/share/man/man5/
  '';

  meta = with lib; {
    description = "GUI, CLI, and library for playing chess";
    homepage = "https://cutechess.com/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eclairevoyant ];
    platforms = with platforms; (linux ++ windows);
    mainProgram = "cutechess";
  };
})
