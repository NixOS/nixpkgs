{ stdenv, fetchFromGitLab, python, ensureNewerSourcesForZipFilesHook }:

stdenv.mkDerivation rec {
  name = "waf-${version}";
  version = "2.0.10";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = name;
    sha256 = "12p5myq72r5qg7wp2gwbnyvh6lzzcrwp9h3dw194x38g52m0prc7";
  };

  buildInputs = [ python ensureNewerSourcesForZipFilesHook ];

  configurePhase = ''
    python waf-light configure
  '';
  buildPhase = ''
    python waf-light build
  '';
  installPhase = ''
    install waf $out
  '';

  meta = with stdenv.lib; {
    description = "Meta build system";
    homepage    = https://waf.io;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
