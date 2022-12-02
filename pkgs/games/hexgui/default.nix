{ ant
, fetchFromGitHub
, jdk
, lib
, makeWrapper
, stdenv
}:
stdenv.mkDerivation {
  pname = "hexgui";
  version = "unstable-2022-5-30";

  src = fetchFromGitHub {
    owner = "selinger";
    repo = "hexgui";
    rev = "d94ce1d35a22dad28d3e7def4d28e6bebd54da9d";
    hash = "sha256-1MroFH2JSEZHFigcsw1+xyHJWEnHTvHmRPVirUgwM6I=";
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
    description = "GUI for the board game Hex (and Y)";
    homepage = "https://github.com/selinger/hexgui";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.ursi ];
  };
}
