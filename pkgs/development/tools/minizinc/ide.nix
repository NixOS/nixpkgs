{ lib, mkDerivation, fetchFromGitHub, qtbase, qtwebengine, qtwebkit, qmake, minizinc }:
mkDerivation rec {
  pname = "minizinc-ide";
  version = "2.5.3";

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine qtwebkit ];

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "MiniZincIDE";
    rev = version;
    sha256 = "1c80ilb1xbgzfadgal668h2zsaiv62il1jnljizrisgb7pszzyzw";
    fetchSubmodules = true;
  };

  sourceRoot = "source/MiniZincIDE";

  dontWrapQtApps = true;

  postInstall = ''
    wrapProgram $out/bin/MiniZincIDE --prefix PATH ":" ${lib.makeBinPath [ minizinc ]}
  '';

  meta = with lib; {
    homepage = "https://www.minizinc.org/";
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
