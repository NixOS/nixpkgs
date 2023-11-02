{ lib, mkDerivation, fetchFromGitHub, qtbase, qtwebengine, qtwebkit, qmake, minizinc }:

mkDerivation rec {
  pname = "minizinc-ide";
  version = "2.7.6";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "MiniZincIDE";
    rev = version;
    sha256 = "sha256-Fwt4zuIKwurCx0EriwSOea4zAJ7Bmr8Stt0dQ8Ux0cs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine qtwebkit ];

  sourceRoot = "${src.name}/MiniZincIDE";

  dontWrapQtApps = true;

  postInstall = ''
    wrapProgram $out/bin/MiniZincIDE --prefix PATH ":" ${lib.makeBinPath [ minizinc ]} --set QT_QPA_PLATFORM_PLUGIN_PATH "${qtbase.bin}/lib/qt-${qtbase.version}/plugins/platforms"
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
