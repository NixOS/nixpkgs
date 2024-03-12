{ ant
, fetchFromGitHub
, jdk
, lib
, makeWrapper
, stdenv
}:
stdenv.mkDerivation {
  pname = "hexgui";
  version = "unstable-2023-1-7";

  src = fetchFromGitHub {
    owner = "selinger";
    repo = "hexgui";
    rev = "62f07ff51db0d4a945ad42f86167cc2f2ce65d90";
    hash = "sha256-yEdZs9HUt3lcrdNO1OH8M8g71+2Ltf+v1RR1fKRDV0o=";
  };

  nativeBuildInputs = [ ant jdk makeWrapper ];
  buildPhase = ''
    ant
  '';

  installPhase = ''
    mkdir $out
    mv bin lib $out
    wrapProgram $out/bin/hexgui --prefix PATH : ${lib.makeBinPath [ jdk ]}
  '';

  meta = {
    description = "GUI for the board game Hex";
    homepage = "https://github.com/selinger/hexgui";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.ursi ];
  };
}
