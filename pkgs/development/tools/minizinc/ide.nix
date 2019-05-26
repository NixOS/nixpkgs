{ stdenv, fetchFromGitHub, qtbase, qtwebengine, qtwebkit, qmake, makeWrapper, minizinc }:
let
  version = "2.2.3";
in
stdenv.mkDerivation {
  name = "minizinc-ide-${version}";

  nativeBuildInputs = [ qmake makeWrapper ];
  buildInputs = [ qtbase qtwebengine qtwebkit ];

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "MiniZincIDE";
    rev = version;
    sha256 = "1hanq7c6li59awlwghgvpd8w93a7zb6iw7p4062nphnbd1dmg92f";
  };

  sourceRoot = "source/MiniZincIDE";

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/MiniZincIDE --prefix PATH ":" ${stdenv.lib.makeBinPath [ minizinc ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://www.minizinc.org/;
    description = "IDE for MiniZinc, a medium-level constraint modelling language";

    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';

    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.dtzWill ];
  };
}
