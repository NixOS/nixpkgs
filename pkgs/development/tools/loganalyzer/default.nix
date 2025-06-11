{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qtsvg,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "loganalyzer";
  version = "23.5.1";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = "loganalyzer";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-k9hOGI/TmiftwhSHQEh3ZVV8kkMSs1yKejqHelFSQJ4=";
  };

  buildInputs = [
    qtbase
    qtsvg
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  sourceRoot = "${src.name}/src";

  buildPhase = ''
    runHook preBuild

    qmake LogAnalyzer.pro CONFIG+=release PREFIX=/
    make

    runHook postBuild
  '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  postInstall = ''
    ln -s $out/bin/LogAnalyzer $out/bin/loganalyzer
  '';

  meta = with lib; {
    description = "Tool that helps you to analyze your log files by reducing the content with patterns you define";
    homepage = "https://github.com/pbek/loganalyzer";
    changelog = "https://github.com/pbek/loganalyzer/blob/develop/CHANGELOG.md";
    downloadPage = "https://github.com/pbek/loganalyzer/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pbek ];
    platforms = platforms.unix;
  };
}
